# encoding: utf-8

require 'net/http'
require 'openssl'
require 'json'

require 'g_stat/helpers'

module GStat
  class Repository

    attr_accessor :owner, :repo

    def initialize(params)
      params.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end

    def run
      releases_report
    end

    def releases_report(indentation=0)
      if releases
        GStat::Helpers::Report.print_infos 'Releases', indentation

        releases.each_with_index do |release, i|
          GStat::Helpers::Report.print_infos([
                        ['Name', release[:name]], ['Tag Name', release[:tag_name]], ['Target', release[:target_commitish]],
                        ['Author', release[:author][:login]], ['Draft', release[:draft]], ['Pre-release', release[:prerelease]],
                        ['HTML URL', release[:html_url]], ['Created At', release[:created_at]], ['Published At', release[:published_at]],
                        ['Assets', '']
          ], indentation + 1)

          (assets = release[:assets]).each_with_index do |asset, j|
            GStat::Helpers::Report.print_infos([
                          ['Name', asset[:name]], ['Download Count', asset[:download_count]],
                          ['Download URL', release_asset_download_url(release[:name], asset[:name])]
            ], indentation + 2)
            puts '' if j < assets.length - 1
          end

          puts '' if i < releases.length - 1
        end
      end
    end

    def releases
      @releases ||= (body = request_body(releases_uri)) ? JSON.parse(body, symbolize_names: true) : []
    end

    private

    def request_body(uri)
      uri = URI uri

      body = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        response = http.request Net::HTTP::Get.new(uri)

        response.body if response.is_a?(Net::HTTPSuccess)
      end
    end

    def releases_uri
      URI "https://api.github.com/repos/#{owner}/#{repo}/releases"
    end

    def release_asset_download_url(release_name, asset_name)
      "https://github.com/#{owner}/#{repo}/releases/download/#{release_name}/#{asset_name}"
    end
  end
end