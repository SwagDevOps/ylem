# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'securerandom'
require 'pathname'

FactoryGirl.define do
  # @see https://github.com/thoughtbot/factory_girl/issues/350
  sequence(:'paths.random') do |n|
    random_paths ||= (1..10).to_a.map do |i|
      Pathname.new('/')
              .join(SecureRandom.hex(2),
                    SecureRandom.hex(4),
                    SecureRandom.hex(6))
    end

    random_paths.sample
  end

  factory :paths, class: FactoryStruct do
    random { FactoryGirl.generate(:'paths.random') }
  end
end
