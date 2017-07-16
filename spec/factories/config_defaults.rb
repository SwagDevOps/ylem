# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryGirl.define do
  factory :config_defaults, class: FactoryStruct do
    # Patterns used to match config file default values
    #
    # rubocop:disable Style/RegexpLiteral
    patterns(
      'logger.file':      /^\/var\/log\/(rake|rspec)\.log$/,
      'scripts.path':     /^\/etc\/(rake|rspec)\/scripts$/,
      'environment.file': /^\/etc\/environment$/
    )
    # rubocop:enable Style/RegexpLiteral
  end
end
