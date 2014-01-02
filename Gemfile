#source 'https://rubygems.org'
source 'http://ruby.taobao.org/'

gem 'rails', '~> 4.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "pg"

gem 'public_activity'



unless RUBY_PLATFORM =~ /mingw|mswin/
  gem 'unicorn'
end

gem 'thin'

#gem 'sqlite3'

gem 'protected_attributes'
gem "redis-objects"

gem "sidekiq"

gem "kaminari"

gem "sanitize"

gem "rest-client"

gem 'yajl-ruby', require: 'yajl'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails'
  # gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development,:test do

    gem 'meta_request'

    gem "better_errors"

    gem "binding_of_caller"

    gem 'rspec-rails'

    #gem 'debugger'

    #gem 'factory_girl_rails'

    #gem 'database_cleaner'

    #gem "rspec-cells"

    gem 'api_taster'

    
end

gem 'newrelic_rpm'

#爬虫
gem 'anemone'
gem 'nokogiri'

gem 'oauth2'

gem 'public_activity'

gem 'ruby-hmac'

#图片处理
#gem 'carrierwave'
gem 'carrierwave-aliyun'
gem 'rmagick'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'


# Deploy with Capistrano
# gem 'capistrano'

#gem 'puma' #跟unicorn进行速度的比较 并发量没有明显提升,多线程节省一些内存

