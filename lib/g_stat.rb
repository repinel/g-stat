# encoding: utf-8

require 'g_stat/version'
require 'g_stat/repository'

module GStat

  extend self

  def run(owner, repo)
    repository = GStat::Repository.new owner: owner, repo: repo
    repository.report
  end

end