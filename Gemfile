source 'https://rubygems.org'
gemspec

unless ENV['CI']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'hanami-utils', '~> 1.3', require: false, git: 'https://github.com/hanami/utils.git', branch: 'master'
gem 'haml',         '~> 5.0', require: false
gem 'slim',         '~> 4.0', require: false

gem 'hanami-devtools', require: false, git: 'https://github.com/hanami/devtools.git'
