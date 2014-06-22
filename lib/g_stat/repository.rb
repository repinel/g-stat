# encoding: utf-8

require 'net/http'
require 'openssl'
require 'json'

require 'g_stat/helpers'

module GStat
  class Repository
    include GStat::Helpers::Report

    GIT_HUB_API_URL = 'https://api.github.com'.freeze

    attr_accessor :owner, :repo

    def initialize(params)
      params.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end

    def report
      puts "GitHub: #{owner}/#{repo}\n\n"

      if exist?
        releases_report
      else
        puts 'DOES NOT EXIST'
      end
    end

    def releases_report(indentation=0)
      if releases
        print_entries 'Releases', indentation

        if releases.empty?
          print_entries 'NONE', indentation + 1
        end

        releases.each_with_index do |release, i|
          print_entries([
                        ['Name', release[:name]], ['Tag Name', release[:tag_name]], ['Target', release[:target_commitish]],
                        ['Author', release[:author][:login]], ['Draft', release[:draft]], ['Pre-release', release[:prerelease]],
                        ['HTML URL', release[:html_url]], ['Created At', release[:created_at]], ['Published At', release[:published_at]],
                        ['Assets', '']
          ], indentation + 1)

          (assets = release[:assets]).each_with_index do |asset, j|
            print_entries([
                          ['Name', asset[:name]], ['Download Count', asset[:download_count]],
                          ['Download URL', release_asset_download_url(release[:name], asset[:name])]
            ], indentation + 2)
            puts '' if j < assets.length - 1
          end

          puts '' if i < releases.length - 1
        end
      end
    end

    def exist?
      !info.nil?
    end

    def info
      @info ||= api_call repository_url
    end

    def releases
      @releases ||= api_call releases_url
    end

    private

    def api_call(uri)
      body = request_body uri
      body ? JSON.parse(body, symbolize_names: true) : nil
    end

    def request_body(uri)
      uri = URI uri

      body = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        response = http.request Net::HTTP::Get.new(uri)

        response.body if response.is_a?(Net::HTTPSuccess)
      end
    end

    def repository_url
      "#{GIT_HUB_API_URL}/repos/#{owner}/#{repo}"
    end

    def releases_url
      "#{repository_url}/releases"
    end

    def release_asset_download_url(release_name, asset_name)
      "https://github.com/#{owner}/#{repo}/releases/download/#{release_name}/#{asset_name}"
    end
  end
end