source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug', '~> 3.7'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 3.9'
  gem 'capybara', '~> 3.29'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'faker', '~> 2.7'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet'
end

gem 'devise', '~> 4.7'
gem 'pundit', '~> 2.0'
gem 'qif', '~> 1.2'
gem 'bootstrap', '~> 4.3'
gem 'jquery-rails', '~> 4.3'
#gem 'chartkick', '~> 2.3', '>= 2.3.4'
# TODO: revert back to upstream chartkick when support for Turbolinks is added
gem "chartkick", github: "thijsre/chartkick", branch: "master"
