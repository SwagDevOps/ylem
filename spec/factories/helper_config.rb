# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'ylem/helper'

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
FactoryGirl.define do
  helper = Ylem::Helper.instance.get('config')

  factory :helper_config, class: FactoryStruct do
    defaults(helper.defaults)
  end
end
