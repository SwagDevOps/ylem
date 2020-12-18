# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ylem'

# Actions are merely called from CLI
module Ylem::Action
  # @formatter:off
  {
    Base: 'base',
    Dump: 'dump',
    Exec: 'exec',
    Start: 'start',
  }.each { |s, fp| autoload(s, "#{__dir__}/action/#{fp}") }
  # @formatter:on

  class << self
    include Ylem::Concern::Helper

    # Get action from a class (using its name)
    #
    # @param [Class] klass
    # @return [Class]
    def from_class(klass)
      get(klass.name.split('::')[-1])
    end

    # Get action from a string
    #
    # @param [Symbol] name
    # @return [Base|Dump|Start|Exec]
    def get(name)
      name = inflector.underscore(name.to_s)
      path = self.name
                 .split('::')
                 .map { |w| inflector.underscore(w) }
                 .push(name)
                 .join('/')

      inflector.resolve(path)
    end

    protected

    # @return Ylem::Helper::Inflector
    def inflector
      helper.get(:inflector)
    end
  end
end
