# frozen_string_literal: true

# bundle install --path vendor/bundle
source 'https://rubygems.org'

group :default do
  gem 'activesupport', '~> 5.1'
  gem 'version_info', '~> 1.9'
  gem 'sys-proc', '~> 1.1'
  gem 'hash_dot', '~> 2.1'
  gem 'dotenv', '~> 2.4'
end

group :development do
  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.56'
end

group :development, :repl do
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.11'
  gem 'pry-coolline', '~> 0.2'
end

group :development, :doc do
  gem 'yard', '~> 0.9'
  # Github Flavored Markdown in YARD
  gem 'redcarpet', '~> 3.4'
  gem 'github-markup', '~> 1.6'
end

group :development, :test do
  gem 'rspec', '~> 3.6'
  gem 'factory_bot', '~> 4.8'
  gem 'hashie', '~> 3.5'
end
