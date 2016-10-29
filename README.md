# Econfig

Econfig is a gem which allows you to easily configure your Ruby applications
in a multitude of ways.

## Installation

Add this to your Gemfile:

``` ruby
gem "econfig"
```

If you're using Rails, you'll want to require the Rails extension:

``` ruby
gem "econfig", require: "econfig/rails"
```

## Accessing config options

Extend your main application module with the Econfig shortcut.

In Rails, you'll want to add this in `config/application.rb`:

``` ruby
module MyApp
  extend Econfig::Shortcut

  class Application < Rails::Application
    # …
  end
end
```

In a modular Sinatra application, extend your controller class and copy its settings to Econfig in `app.rb`:
``` ruby
require 'sinatra'
require 'econfig'

class MyApp < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  # …
end
```

In either case, you can now you can access configuration like this:

``` ruby
MyApp.config.aws_access_key_id
```

If the key you accessed is not configured, Econfig will raise an error. To
access optional configuration, which can be nil, use brackets:

``` ruby
MyApp.config[:aws_access_key_id]
```

Sometimes you might want to bypass the strictness requirement in econfig, for
example if you're running the application as part of a build process.  In that
case you can set the environment variable `ECONFIG_PERMISSIVE`, and econfig
will not raise errors on missing keys, instead returning `nil`.

## Configuring options.

You can specify configuration through:

1. ENV variables
2. Redis
3. Relational database
4. YAML files
5. OSX Keychain

This allows you to set up Econfig on most kinds of hosting solutions
(EngineYard, Heroku, etc) without any additional effort, and to switch between
them easily.

### ENV variables

Just set an environment variable whose name is the name of the option being
accessed uppercased.

For example:

``` sh
AWS_ACCESS_KEY_ID=xyz rails server
```

You can now read it like this:

``` ruby
MyApp.config.aws_access_key_id # => "xyz"
```

This is especially convenient for Heroku.

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

Econfig also reads configuration from `config/secret.yml` which is the new
standard for secret configuration parameters in Rails 4.1.

### Relational database

This needs to be explicitly enabled. In `config/application.rb` add this code:

``` ruby
require "econfig/active_record"
Econfig.backends.insert_after :env, :db, Econfig::ActiveRecord.new
```

You probably want environment variables to take precendence over configuration
from ActiveRecord, hence the `insert_after`. If you'd rather have ActiveRecord
configuration take precendence you can use this instead:

``` ruby
require "econfig/active_record"
Econfig.backends.unshift :db, Econfig::ActiveRecord.new
```

You will also need to create a migration to create the necessary database tables:

``` sh
rails generate econfig:migration
rake db:migrate
```

### Redis

This needs to be explicitly enabled. In `config/application.rb` add this code:

``` ruby
require "econfig/redis"
redis = Redis.new(:host => "myredis.com")
Econfig.backends.insert_after :env, :redis, Econfig::Redis.new(redis)
```

If you wish to namespace your keys in Redis, you can use [redis namespace](http://rubygems.org/gems/redis-namespace).

### OSX Keychain

For the OSX keychain backend, see [econfig-keychain](https://github.com/elabs/econfig-keychain).

## Setting values

You can set options by simply assigning them:

``` ruby
MyApp.config[:aws_access_key_id] = "xyz"
```

This will set the value in the default write backend, which by default is
`:memory`. This means that by default, configuration which is set like this is
not persisted in any way.

If you always want to assign values to a different backend, for example the
database backend, you can set the default write backend like this:

``` ruby
Econfig.default_write_backend = :db
```

You can also explicitly supply the backend when setting a configuration value:

``` ruby
MyApp.config[:db, :aws_access_key_id] = "xyz"
```

## License

MIT, see separate LICENSE.txt file
