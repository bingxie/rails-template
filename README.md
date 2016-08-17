# rails-template

A best & newest & fastest rails template for chinese senior rails developer.

It's a best start for your new rails project.

An example built with rails-template: https://github.com/bingxie/rails-template-example

## How to use

Install dependencies:

* postgresql

    `$ brew install postgresql`

    Ensure you have already initalized a user with username: `postgres` and password: `postgres`( e.g. `$ createuser -d postgres` )

* rails 5

    Update `ruby` up to 2.2 or higher, and install `rails 5`

    `$ ruby -v` ( output should be 2.2.x or 2.3.x )

    `$ gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/` (optional)

    `$ gem install rails`

    `$ rails -v` ( output should be rails 5.x )

Then,

1. Add `gems.ruby-china.org` to your bundle mirrors (optional)

    `$ bundle config mirror.https://rubygems.org https://gems.ruby-china.org`

2. Create your own rails app applying `rails-template`

    `$ rails new myapp -m https://raw.github.com/bingxie/rails-template/master/composer.rb`

3. Start your application

    `$ gem install foreman`
    `$ foreman start`

## What we do

`rails-template` apply lots of good components for you to make development damn quick.

1. we use `Ruby on Rails 5`, `ActionCable` and `Turbolinks` features are opened by default.

2. `Bootstrap3` and `font-awesome` are integrated to make your products UI easily, it aslo has some example pages for you to quickly start.

3. `carriewave` and `carriewave-qiniu` are integrated.

4. `mina` and its plugins are the best & simplest deployment tools in the world for rails app.

5. You can chose from `rspec` or `minitest`.

6. `slim`, `simple_form`, `high_voltage` and so on.

Other gems integrated in rails-template are worth learning seriously.

## Integrated mainly technology stack

* Ruby on Rails 5
* bootstrap 3
* font-awesome
* figaro
* postgres
* slim
* simple_form
* high_voltage
* carriewave & qiniu
* sidekiq
* kaminari
* mina
* puma
* lograge
* rack-mini-profiler
* rubocop
* foreman

## Thanks

[80percent team](https://www.80percent.io)

## LICENSE

MIT
