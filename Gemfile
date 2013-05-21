source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'rate_limited_scheduler' # why reinvent the wheel, right?
gem 'redis' # for rate_limited_scheduler gem
gem 'redis-namespace'
gem 'jquery-rails'
gem 'fb_graph' # used to send api calls to facebook

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
end
