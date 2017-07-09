# frozen_string_literal: true

require 'ylem/action/base'
require 'open3'

# Action triggered by CLI ``start`` command
#
# This action will execute scripts (listed as ``executables`` by ``config``)
# one by one, procedurally. At the end, ``retcode`` denote
# any error issued during scripts execution.
# In this case, a ``retcode`` equal to
# ``Errno::ENOTRECOVERABLE::Errno`` (``131``) is used.
#
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
      # rubocop:disable Style/Next
      unless script.execute(logger: logger, as: :basename).zero?
        self.retcode = :ENOTRECOVERABLE

        return self
      end
      # rubocop:enable Style/Next
    end

    self
  end
end
