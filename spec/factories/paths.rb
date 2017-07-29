# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'securerandom'
require 'pathname'

FactoryGirl.define do
  factory :paths, class: FactoryStruct do
    # get 10 random paths
    random((1..10).to_a.map do |i|
      Pathname.new('/')
              .join(SecureRandom.hex(2),
                    SecureRandom.hex(4),
                    SecureRandom.hex(6))
    end)
  end
end
