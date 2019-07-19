# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

lock = Dir.chdir("#{__dir__}/..") do
  [['gems.rb', 'gems.locked'], ['Gemfile', 'Gemfile.lock']]
    .map { |m| Dir.glob(m).size >= 2 }
    .include?(true)
end

if lock
  require 'rubygems'
  require 'bundler/setup'

  if Gem::Specification.find_all_by_name('kamaze-project').any?
    require 'kamaze/project/core_ext/pp'
  end
end

# Base module (namespace)
module Ylem
  require 'English'
  autoload(:Pathname, 'pathname')

  # @formatter:off
  {
    VERSION: 'version',
    Action: 'action',
    Cli: 'cli',
    Concern: 'concern',
    Helper: 'helper',
    Service: 'service',
    Type: 'type',
  }.each { |s, fp| autoload(s, Pathname.new(__dir__).join("ylem/#{fp}")) }
  # @formatter:on
end
