# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'pathname'
require 'sys-proc'

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
FactoryGirl.define do
  progname = Sys::Proc.progname

  factory :helper_config, class: FactoryStruct do
    defaults(
      'logger.file':      Pathname.new('/var')
                                  .join('log', "#{progname}.log"),
      'logger.level':     :info,
      'scripts.path':     Pathname.new('/etc')
                                  .join(progname, 'scripts'),
      'environment.file': Pathname.new('/etc').join('environment')
    )
  end
end
