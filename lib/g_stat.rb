# encoding: utf-8

require "g_stat/version"
require 'g_stat/repository'

module GStat

  extend self

  def run(owner, repository)
    repo = GStat::Repository.new owner: owner, repo: repository
    repo.run
  end

end