def remove_gem(*names)
  names.each do |name|
    gsub_file 'Gemfile', /gem '#{name}'\n/, ''
  end
end

def remove_comment_of_gem
  gsub_file('Gemfile', /^\s*#.*$\n/, '')
end

def get_remote(src, dest = nil)
  dest ||= src
  repo = 'https://raw.github.com/bingxie/rails-template/master/files/'
  remote_file = repo + src
  remove_file dest
  get(remote_file, dest)
end

remove_comment_of_gem
# gitignore
get_remote('gitignore', '.gitignore')

# postgresql
say 'Applying postgresql...'
remove_gem('sqlite3')
gem 'pg'
get_remote('config/database.yml.example')
gsub_file "config/database.yml.example", /database: myapp_development/, "database: #{app_name}_development"
gsub_file "config/database.yml.example", /database: myapp_test/, "database: #{app_name}_test"
gsub_file "config/database.yml.example", /database: myapp_production/, "database: #{app_name}_production"
get_remote('config/database.yml.example', 'config/database.yml')
gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name}_development"
gsub_file "config/database.yml", /database: myapp_test/, "database: #{app_name}_test"
gsub_file "config/database.yml", /database: myapp_production/, "database: #{app_name}_production"

# environment variables set
say 'Applying figaro...'
gem 'figaro'
get_remote('config/application.yml.example')
get_remote('config/application.yml.example', 'config/application.yml')
get_remote('config/spring.rb')

# bootstrap sass
say 'Applying bootstrap3...'
gem 'bootstrap-sass'
remove_file 'app/assets/stylesheets/application.css'
get_remote('application.scss', 'app/assets/stylesheets/application.scss')
inject_into_file 'app/assets/javascripts/application.js', after: "//= require jquery\n" do "//= require bootstrap-sprockets\n" end

if yes?("Do you want to use Simple Form?")
  say 'Applying simple_form...'
  gem 'simple_form'
  after_bundle do
    generate 'simple_form:install', '--bootstrap'
  end
end

say 'Applying font-awesome & slim & high_voltage...'
gem 'font-awesome-sass'
gem 'slim-rails'
gem 'high_voltage', :github=>"thoughtbot/high_voltage"
get_remote('visitors_controller.rb', 'app/controllers/visitors_controller.rb')
get_remote('index.html.slim', 'app/views/visitors/index.html.slim')
get_remote('about.html.slim', 'app/views/pages/about.html.slim')
remove_file('app/views/layouts/application.html.erb')
get_remote('application.html.slim', 'app/views/layouts/application.html.slim')
gsub_file 'app/views/layouts/application.html.slim', /myapp/, "#{app_name}"

say 'Applying action cable config...'
inject_into_file 'config/environments/production.rb', after: "# Mount Action Cable outside main process or domain\n" do <<-EOF
  config.action_cable.allowed_request_origins = [ "#{ENV['PROTOCOL']}://#{ENV['DOMAIN']}" ]
EOF
end

# initialize files
# uploader directory
# application.yml
say 'Applying carrierwave & qiniu...'
gem 'carrierwave'
gem 'carrierwave-qiniu', '~> 0.2.1'
get_remote('config/initializers/carrierwave.rb')
get_remote('image_uploader.rb', 'app/uploaders/image_uploader.rb')

# initialize files
say 'Applying status page...'
gem 'status-page'
get_remote('config/initializers/status_page.rb')

say 'Applying redis & sidekiq...'
gem 'redis-namespace'
gem 'sidekiq'
gem 'sinatra', github: 'sinatra', require: false
get_remote('config/initializers/sidekiq.rb')
get_remote('config/routes.rb')

say 'Applying kaminari & rails-i18n...'
gem 'kaminari', github: 'amatsuda/kaminari'
gem 'rails-i18n', '~> 5.0.0'
after_bundle do
  generate 'kaminari:config'
  generate 'kaminari:views', 'bootstrap3'
end

say 'Applying mina & its plugin...'
gem 'mina-puma', require: false
gem 'mina-multistage', '~> 1.0', '>= 1.0.2', require: false
gem 'mina-sidekiq', '~> 0.3.1', require: false
gem 'mina-logs', '>= 0.1.0', require: false
get_remote('config/deploy.rb')
get_remote('config/puma.rb')
gsub_file 'config/puma.rb', /\/data\/www\/myapp\/shared/, "/data/www/#{app_name}/shared"
get_remote('config/deploy/production.rb')
gsub_file 'config/deploy/production.rb', /\/data\/www\/myapp/, "/data/www/#{app_name}"
get_remote('config/nginx.conf.example')
gsub_file 'config/nginx.conf.example', /myapp/, "#{app_name}"

say 'Applying lograge & basic application config...'
gem 'lograge'
inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-EOF
    config.generators.assets = false
    config.generators.helper = false

    config.time_zone = 'Beijing'
    config.i18n.available_locales = [:en, :'zh-CN']
    config.i18n.default_locale = :'zh-CN'

    config.lograge.enabled = true
EOF
end

if yes?("Do you want to use Rspec instead of Minitest?")
  say 'Applying rspec test framework...'
  gem_group :development do
    gem 'rails_apps_testing'
  end
  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'factory_girl_rails'
  end
  gem_group :test do
    gem 'capybara'
    gem 'database_cleaner'
    gem 'launchy'
    gem 'selenium-webdriver'
  end
  after_bundle do
    generate 'testing:configure', 'rspec --force'
  end
else
  # Add gems for minitest
  gem_group :test do
    gem "minitest-reporters"

    gem 'capybara'
    gem "connection_pool"
    gem "launchy"
    gem "selenium-webdriver"

    gem "mocha"
    gem "poltergeist"
    gem 'phantomjs', require: 'phantomjs/poltergeist'
  end

  get_remote('test/test_helper.rb', 'test/test_helper.rb')
  get_remote('test/features/about_page_test.rb', 'test/features/about_page_test.rb')
end

get_remote 'README.md'
gsub_file 'README.md', /myapp/, "#{app_name}"
# `ack` is a really quick tool for searching code
get_remote 'ackrc', '.ackrc'

after_bundle do
  say 'Done! init `git` and `database`...'
  git :init
  git add: '.'
  git commit: '-m "init rails"'

  rake 'db:create'

  say 'Build successfully! Use `rails s` to start your rails app...'
end
