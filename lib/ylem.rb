# frozen_string_literal: true

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

  autoload :VERSION, 'ylem/VERSION'
end
