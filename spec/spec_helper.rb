# frozen_string_literal: true

[
  :project,
  :progname,
  :matchers,
  :constants,
  :factory_struct,
  :configure,
].each do |s|
  require [__dir__, 'spec_helper', s].map(&:to_s).join('/')
end
