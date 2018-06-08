# frozen_string_literal: true

require 'pathname'
require 'sys-proc'

progname = Sys::Proc.progname

# Sample of expected results:
#
# defaults:
#
# ````
# {:"logger.file"=>#<Pathname:/var/log/rake.log>,
#  :"logger.level"=>:info,
#  :"scripts.path"=>#<Pathname:/etc/rake/scripts>,
#  :"environment.file"=>#<Pathname:/etc/environment>}
# ````
#
# @see Ylem::Helper::Config#defaults
Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    {
      defaults: {
        'logger.file': Pathname.new('/var').join('log', "#{progname}.log"),
        'logger.level': :info,
        'scripts.path': Pathname.new('/etc').join(progname, 'scripts'),
        'environment.file': Pathname.new('/etc').join('environment'),
      }
    }
  end
end
