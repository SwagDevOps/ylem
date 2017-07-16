# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryGirl.define do
  factory :config_defaults, class: FactoryStruct do
    # Patterns used to match config file default values
    patterns(
      'logger.file':      %r{^/var/log/(rake|rspec).log$},
      'scripts.path':     %r{^/etc/(rake|rspec)/scripts$},
      'environment.file': %r{^/etc/environment$}
    )
  end
end
