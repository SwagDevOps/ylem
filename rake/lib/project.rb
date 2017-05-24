# frozen_string_literal: true

class Project
  class << self
    # @return [Symbol]
    def name
      ENV.fetch('PROJECT_NAME').to_sym
    end

    # Main class (subject of project)
    #
    # @return [Class]
    def subject
      name = self.name.to_s.gsub('-', '/')
      inflector.constantize(inflector.classify(name))
    end

    # Gem specification
    #
    # @return [Gem::Specification]
    def spec
      Gem::Specification::load('%s/%s.gemspec' % [Dir.pwd, name])
    end

    # @return [Hash]
    def version_info
      ({version: subject.VERSION.to_s}.merge(subject.version_info)).freeze
    end

    # Gem (packaged)
    #
    # @return [Pathname]
    def gem
      Pathname.new('pkg').join("#{spec.name}-#{spec.version}.gem")
    end

    protected

    # Load project main lib (and dependencies)
    #
    # @return [self]
    def autoload
      require 'active_support/inflector'
      require 'dotenv/load'
      require '%s/lib/%s' % [Dir.pwd, name]

      self
    end

    # @return [ActiveSupport::Inflector]
    def inflector
      ActiveSupport::Inflector
    end
  end

  self.autoload
end
