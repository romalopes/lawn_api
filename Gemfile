source 'https://rubygems.org'
ruby "2.0.0"


group :test do
  # gem "rack-test"
  gem "rake"
  gem 'rspec-rails', '2.13.1'
  gem 'guard-rspec', '2.5.0'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'  
end

gem 'lawn_mowing', '0.1.0',  :path=>'lawn_mowing'
# gem 'lawn_mowing', :git => 'git://github.com/romalopes/lawn_mowing.git'

source 'https://rubygems.org'
ruby "2.0.0"

gem "sinatra"
gem "json"
gem "activerecord"
gem "sinatra-activerecord"
gem 'sinatra-flash'
gem 'sinatra-redirect-with-flash'

group :development do
 gem 'sqlite3'
 gem "tux"
end

group :production do
  gem 'pg'#, '0.15.1'
  # gem 'rails_12factor', '0.0.2'
end