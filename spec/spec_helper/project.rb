# -*- coding: utf-8 -*-

require 'dotenv'

Dotenv.load

require '%s/../../lib/%s' % [__dir__, ENV.fetch('PROJECT_NAME')]
