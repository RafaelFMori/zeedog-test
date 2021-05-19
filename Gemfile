source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2.3'
gem 'sqlite3', '1.4.1'
gem 'puma', '~> 4.3'
gem 'dry-validation', '1.2.1'
gem 'dry-transaction', '0.13.0'
gem 'typhoeus', '1.3.1'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'jwt', '2.2.1'

group :test do
  gem 'factory_bot_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8.2'
  gem 'simplecov', '0.17.0'
  gem 'simplecov-rcov', '0.2.3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring', '~> 2.1.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rails', '1.4.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
