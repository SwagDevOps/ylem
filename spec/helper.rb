# frozen_string_literal: true

[
  :project,
  :progname,
  :matchers,
  :constants,
  :factory_struct,
  :configure,
].each { |s| require [__dir__, 'helper', s].map(&:to_s).join('/') }
