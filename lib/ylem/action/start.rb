# frozen_string_literal: true

require 'ylem/action/base'
require 'open3'

# Action triggered by CLI ``start`` command
#
# This action will execute scripts (listed as ``executables`` by ``config``)
# one by one, procedurally. At the end, ``status`` SHOULD denote
# any error issued during execution of any script.
#
# @todo ``retcode`` SHOULD denote any issued script error,
#   may be use ``ENOTRECOVERABLE``
# @todo Implement a ``-k``, ``--keep-going`` option
class Ylem::Action::Start < Ylem::Action::Base
  def execute
    execute_scripts(scripts)
  end

  # Get scripts (to be executed)
  #
  # @return [Array<Ylem::Type::Script>]
  def scripts
    config.scripts.executables
  end

  protected

  # Execute scripts
  #
  # @param [Array<Ylem::Type::Script>] scripts
  def execute_scripts(scripts)
    scripts.each do |script|
      unless script.execute(logger: logger, as: :basename).zero?
        # @todo set ``retcode`` and break loop
        logger.error("failed (#{status})")
      end
    end

    self
  end
end
