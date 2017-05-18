# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
#
# Should follow the higher required_ruby_version
# at the moment, gem with higher required_ruby_version is activesupport

Gem::Specification.new do |s|
  s.name        = '#{@name}'
  s.version     = '#{@version}'
  s.date        = '#{@date}'
  s.summary     = '#{@summary}'
  s.description = '#{@description}'

  s.licenses    = #{@licenses}
  s.authors     = #{@authors}
  s.email       = '#{@email}'
  s.homepage    = '#{@homepage}'

  s.required_ruby_version = '>= 2.2.2'
  s.require_paths = ['lib']
  s.files         = Dir.glob('**/**.rb') + \
                    Dir.glob('**/version_info.yml')

  #{@dependencies}
end

# Local Variables:
# mode: ruby
# End:
