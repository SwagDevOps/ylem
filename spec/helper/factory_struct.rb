# -*- coding: utf-8 -*-

require 'hashie'

# Generic struct (ala OpenStruct) based on Hashie
class FactoryStruct < Hash
  include Hashie::Extensions::MethodAccess
end
