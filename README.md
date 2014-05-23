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
MyApp.config.aws_access_key_id
```

which is obviously way more convenient. The rest of this README is going to
assume that you added this shortcut.

## Accessing optional configuration

If the key you accessed is not configured, econfig will raise an error. To
access optional configuration, which can be nil, use brackets:

``` ruby
MyApp.config[:aws_access_key_id]
```

## Configuring options.

You can specify configuration through:

1. ENV variables
2. Redis
3. Relational database
4. YAML files
5. OSX Keychain

This allows you to set up econfig on most kinds of hosting solutions
(EngineYard, Heroku, etc) without any additional effort, and to switch between
them easily. The options are listed in descending order of preference.

### ENV variables

Just set an environment variable whose name is the name of the option being
accessed uppercased.

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
Econfig.use_redis Redis.new(:host => "myredis.com")
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

### OSX Keychain

For the OSX keychain backend, see [econfig-keychain](https://github.com/elabs/econfig-keychain).

## License

MIT, see separate LICENSE.txt file
