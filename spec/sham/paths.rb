# frozen_string_literal: true

require 'securerandom'
require 'pathname'

Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    {
      randomizer: lambda do
        sec_rand = SecureRandom
        path = Pathname.new('/')

        path.join(sec_rand.hex(2), sec_rand.hex(4), sec_rand.hex(6))
      end,
    }
  end
end
