# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'pathname'

# Parsed config values, as ``Ylem::Helper::Config#parse_file()`` result
#
# @see ``config_paths``
# @todo test consistency
#
# Each dataset SHOULD match given config path
FactoryGirl.define do
  factory(:config_values, class: FactoryStruct) do
    success(
      'logger.file':      Pathname.new(SPEC_DIR)
                                  .join('log/success.log'),
      'logger.level':     :DEBUG,
      'scripts.path':     Pathname.new(SAMPLES_DIR)
                                  .realpath
                                  .join('scripts/success'),
      'environment.file': Pathname.new(SAMPLES_DIR)
                                  .realpath
                                  .join('environment')
    )
  end
end
