# Econfig

Econfig is a gem which allows you to easily configure your Rails applications
in a multitude of ways.

## Installation

Add this to your gemfile:

``` ruby
gem "econfig", :require => "econfig/rails"
```

## Accessing config options

Econfig extends the Rails configuration, you can use it like this:

``` ruby
MyApp::Application.config.app.aws_access_key
```

Where `MyApp` is the name of your application and `aws_access_key` is whatever
property you want to access. We recommend you add the shortcut module so you
can access config options directly:

``` ruby
module MyApp
  extend Econfig::Shortcut

  …
end
```

In `config/application.rb`. This will give you:

``` ruby
MyApp.aws_access_key_id
```

which is obviously way more convenient. The rest of this README is going to
assume that you added this shortcut.

## Forcing an option to exist

Sometimes you want the application to crash early when a given config option is
not set. Just add a bang (!) after the option name, and an error will be thrown
if it is not set to a value which is present.

``` ruby
MyApp.aws_access_key_id!
```

## Configuring options.

You can specify configuration through:

1. ENV variables
2. Redis
3. Relational database
4. YAML files

This allows you to set up econfig on most kinds of hosting solutions
(EngineYard, Heroku, etc) without any additional effort, and to switch between
them easily. The options are listed in descending order of preference.

### ENV variables

Just set an environment variable whose name is the name of the option being accessed uppercased.

For example:

``` sh
AWS_ACCESS_KEY_ID=xyz rails server
```

This is especially convenient for Heroku.

### Relational database

This needs to be explicitly enabled. In `config/application.rb` add this line:

``` ruby
Econfig.use_database
```

You will also need to create a migration to create the necessary database tables:

``` sh
rails generate econfig:migration
rake db:migrate
```

You can now set options by assigning them:

``` ruby
MyApp.aws_access_key_id = "xyz"
```

You may not use both Redis and relational database storage at the same time.

### Redis

This needs to be explicitly enabled. In `config/application.rb` add this line:

``` ruby
Econfig.use_redis
```

You can configure this further:

``` ruby
Econfig.use_redis :host => "myredis.com"
```

You can now set options by assigning them:

``` ruby
MyApp.aws_access_key_id = "xyz"
```

You may not use both Redis and relational database storage at the same time.

### YAML

Add a yaml file to `config/app.yml`. This should have a similar layout to `config/database.yml`:

``` yaml
development:
  aws_access_key_id: "xyz"
  aws_secret_access_key: "xyz"
production:
  aws_access_key_id: "xyz"
  aws_secret_access_key: "xyz"
```

## License

(The MIT License)

Copyright (c) 2012 Elabs AB

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
