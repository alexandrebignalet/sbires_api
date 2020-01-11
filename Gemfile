source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.6.1'

gem 'rails', '~> 5.2.3'
gem 'sqlite3'
gem 'puma', '~> 4.3'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'sbires', git: 'git://github.com/alexandrebignalet/sbires.git'

gem 'jwt'
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors','~>0.4.1'
gem 'httparty'

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]