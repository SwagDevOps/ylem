# frozen_string_literal: true

[
  :progname,
  :dotenv,
  :matchers,
  :constants,
  :factory_struct,
  :configure,
].each { |s| require [__dir__, 'helper', s].map(&:to_s).join('/') }

require '%s/../lib/%s' % [__dir__, ENV.fetch('PROJECT_NAME')]
