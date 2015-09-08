source 'https://rubygems.org'
ruby '2.2.2'
gem 'rails', '4.2.1'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'paper_trail', '~> 3.0.6'
gem "stripe", '= 1.24.0'
# gem "jquery-validation-rails"
group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
gem 'bootstrap-sass'
gem 'devise'
gem 'mysql2'
gem 'pg'
gem "econfig", require: "econfig/rails"
group :development do
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'spring-commands-rspec'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  # gem 'stripe-ruby-mock' , '~> 2.1.1', require: 'stripe_mock' # normal setting
  gem 'stripe-ruby-mock', git: 'git://github.com/kathyonu/stripe-ruby-mock', branch: 'stripe-1.24.0', require: 'stripe_mock'
  gem 'sqlite3'
  gem 'thin', '~> 1.6.3'
end
group :production do
  gem 'rails_12factor'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end
