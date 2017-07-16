# -*- coding: utf-8 -*-

# Paths to success + failure configuration files
#
# default config path is a pattern, as progname is dynamic
FactoryGirl.define do
  factory :config_paths, class: FactoryStruct do
    success "#{SAMPLES_DIR}/config/success.yml"
    failure "#{SAMPLES_DIR}/config/failure.yml"
    default %r{^/etc/(rake|rspec)/config\.yml$}
  end
end
