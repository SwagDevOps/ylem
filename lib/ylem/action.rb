# frozen_string_literal: true

require 'ylem'
require 'ylem/concern/helper'

# Actions are merely called from CLI
module Ylem::Action
  class << self
    include Ylem::Concern::Helper

    # Get action from a class (using its name)
    #
    # @param [Class] cl
    # @return [Class]
    def from_class(cl)
      get(cl.name.split('::')[-1])
    end

    # Get action from a string
    #
    # @param [Class] name
    # @return [Class]
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
