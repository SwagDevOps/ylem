# frozen_string_literal: true

require 'ylem'

# CLI interface
class Ylem::Cli
  class << self
    def run(*args, &block)
      self.new(*args, &block).run
    end
  end

  def run

  end
end
