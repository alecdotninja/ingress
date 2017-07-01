source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'

gem 'pg'
gem 'paperclip', '~> 5.0.0'

gem 'puma', '~> 3.7'

gem 'sass-rails', '~> 5.0'
gem 'haml'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'bootstrap-sass', '~> 3.3.5'

gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-failures'
gem 'sinatra', require: nil
gem 'redis-namespace'

gem 'mina'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', '~> 0.49.1', require: false

  gem 'pry-rails'
  gem 'pry-stack_explorer'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
