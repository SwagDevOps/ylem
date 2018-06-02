# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

# Should follow the higher required_ruby_version
# at the moment, gem with higher required_ruby_version is activesupport

Gem::Specification.new do |s|
  s.name        = 'ylem'
  s.version     = '0.0.1'
  s.date        = '2017-05-18'
  s.summary     = 'Kind of init process'
  s.description = 'A simple init scheme for Unix-like operating systems that initializes processes'

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = 'dimitri@arrigoni.me'
  s.homepage    = 'https://github.com/SwagDevOps/ylem'

  # Require version >= 2.3.0 with safe navigation operator &.
  s.required_ruby_version = '>= 2.3.0'
  s.require_paths = ['lib']
  s.bindir        = 'bin'
  s.executables   = Dir.glob('bin/*').map { |f| File.basename(f) }
  s.files         = ['.yardopts',
                     'bin/*',
                     'lib/**/*.rb',
                     'lib/**/version_info.yml'
                    ].map { |pt| Dir.glob(pt) }.flatten

  s.add_runtime_dependency("activesupport", ["~> 5.1"])
  s.add_runtime_dependency("version_info", ["~> 1.9"])
  s.add_runtime_dependency("sys-proc", ["~> 1.1"])
  s.add_runtime_dependency("hash_dot", ["~> 2.1"])
  s.add_runtime_dependency("dotenv", ["~> 2.4"])
end

# Local Variables:
# mode: ruby
# eval: (rufo-minor-mode 0);
# End:
