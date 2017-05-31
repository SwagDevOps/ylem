# frozen_string_literal: true

require 'ylem/helper'
require 'ylem/concern/helper'
require 'etc'
require 'pathname'

# Config helper
class Ylem::Helper::Config
  include Ylem::Concern::Helper

  # Default config
  #
  # @return [Hash]
  def defaults
    {
      log_file: Pathname.new('/').join('var', 'log', "#{progname}.log"),
      scripts_dir: Pathname.new(Etc.sysconfdir).join(progname, 'scripts'),
      env_file: Pathname.new(Etc.sysconfdir).join('environment')
    }
  end

  # Default config file
  #
  # @return [Pathname]
  def default_file
    Pathname.new(Etc.sysconfdir).join(progname, 'config.yml')
  end

  # Parse comfig (yaml) file
  #
  # @param [Pathname|String] filepath
  # @return [Hash]
  def parse(filepath = default_file)
    filepath = Pathname.new(filepath)

    parsed = proc do
      if filepath == default_file and !filepath.exist?
        {}
      else
        helper.get('yaml').parse_file(filepath)
      end
    end.call

    defaults.merge(parsed)
  end

  protected

  # @return [String]
  def progname
    helper.get('system').progname
  end
end
