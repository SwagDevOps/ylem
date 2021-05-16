# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

Gem::Specification.new do |s|
  s.name        = "ylem"
  s.version     = "1.0.7"
  s.date        = "2021-03-18"
  s.summary     = "Kind of init process"
  s.description = "A simple init scheme for Unix-like operating systems that initializes processes"

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/ylem"

  s.required_ruby_version = ">= 2.5.0"
  s.require_paths = ["lib"]
  s.bindir        = "bin"
  s.executables   = [
    "ylem",
  ]
  s.files         = [
    ".yardopts",
    "README.md",
    "bin/ylem",
    "lib/ylem.rb",
    "lib/ylem/action.rb",
    "lib/ylem/action/base.rb",
    "lib/ylem/action/dump.rb",
    "lib/ylem/action/exec.rb",
    "lib/ylem/action/start.rb",
    "lib/ylem/bundleable.rb",
    "lib/ylem/cli.rb",
    "lib/ylem/cli/base.rb",
    "lib/ylem/cli/dump.rb",
    "lib/ylem/cli/exec.rb",
    "lib/ylem/cli/start.rb",
    "lib/ylem/concern.rb",
    "lib/ylem/concern/action.rb",
    "lib/ylem/concern/cli.rb",
    "lib/ylem/concern/cli/output.rb",
    "lib/ylem/concern/cli/parse.rb",
    "lib/ylem/concern/cli/progname.rb",
    "lib/ylem/concern/helper.rb",
    "lib/ylem/concern/output.rb",
    "lib/ylem/concern/service.rb",
    "lib/ylem/concern/timed_output.rb",
    "lib/ylem/gc.rb",
    "lib/ylem/helper.rb",
    "lib/ylem/helper/config.rb",
    "lib/ylem/helper/config/decorator.rb",
    "lib/ylem/helper/config/scripts_lister.rb",
    "lib/ylem/helper/config_reader.rb",
    "lib/ylem/helper/errno.rb",
    "lib/ylem/helper/inflector.rb",
    "lib/ylem/helper/subprocess.rb",
    "lib/ylem/helper/subprocess/manager.rb",
    "lib/ylem/helper/subprocess/streamer.rb",
    "lib/ylem/helper/system.rb",
    "lib/ylem/helper/system/path.rb",
    "lib/ylem/helper/timed_output.rb",
    "lib/ylem/helper/yaml.rb",
    "lib/ylem/service.rb",
    "lib/ylem/service/logger.rb",
    "lib/ylem/type.rb",
    "lib/ylem/type/option_parser.rb",
    "lib/ylem/type/script.rb",
    "lib/ylem/version.rb",
    "lib/ylem/version.yml",
  ]

  s.add_runtime_dependency("dotenv", ["~> 2.7"])
  s.add_runtime_dependency("dry-inflector", ["~> 0.1"])
  s.add_runtime_dependency("hash_dot", ["~> 2.4"])
  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
  s.add_runtime_dependency("rouge", ["~> 3.26"])
  s.add_runtime_dependency("stibium-bundled", ["~> 0.0.1", ">= 0.0.4"])
  s.add_runtime_dependency("sys-proc", ["~> 1.1", ">= 1.1.2"])
end

# Local Variables:
# mode: ruby
# End:
