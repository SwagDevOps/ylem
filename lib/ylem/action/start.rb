# frozen_string_literal: true

require 'ylem/action/base'
require 'open3'

# Action triggered by CLI ``start`` command
#
# This action will execute scripts (listed as ``executables`` by ``config``)
# one by one, procedurally. At the end, ``status`` SHOULD denote
# any error issued during execution of any script.
#
# @todo ``retcode`` SHOULD denote any issued, may be use ``ENOTRECOVERABLE``
# @todo Implement a ``-k``, ``--keep-going`` option
class Ylem::Action::Start < Ylem::Action::Base
  def execute
    execute_scripts(scripts)
  end

  # Get scripts (to be executed)
  #
  # @return [Array<Ylem::Type::Script|Pathname>]
  def scripts
    config.scripts.executables
  end

  protected

  # Execute scripts
  #
  # @param [Array<Ylem::Type::Script|Pathname>]
  def execute_scripts(scripts)
    subprocess = helper.get('subprocess')

    scripts.each do |script|
      logger = self.logger.as(script.basename)

      # @todo set ``retcode`` and break loop
      status = subprocess.run([script], logger: logger).to_i
      if status != 0
        logger.error("failed (#{status})")
      end
    end

    self
  end
end
