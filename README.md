# Capistrano::DelayedJob [![Gem Version](https://badge.fury.io/rb/capistrano3-delayed-job.png)](http://badge.fury.io/rb/capistrano3-delayed-job)

Delayed Job support for Capistrano 3.x

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano3-delayed-job', '~> 1.0'
    gem 'capistrano'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano3-delayed-job

## Usage

Require in `Capfile` to use the default task:

```ruby
require 'capistrano/delayed-job'
```

You will get the following tasks

```ruby
cap delayed_job:start                    # Start delayed_job service
cap delayed_job:stop                     # Stop delayed_job service
cap delayed_job:reload                   # Reload delayed_job service
```

Configurable options (copy into deploy.rb), shown here with examples:

```ruby
# Number of delayed_job workers
# default value: 1
set :delayed_job_workers, 2

# Delayed_job queue or queues
# Set the --queue or --queues option to work from a particular queue.
# default value: nil
set :delayed_job_queues, ['mailer','tracking']

# Specify different pools
# You can use this option multiple times to start different numbers of workers for different queues.
# default value: nil
set :delayed_job_pools, {
    :mailer => 2,
    :tracking => 1,
    :* => 2
}

# Set the roles where the delayed_job process should be started
# default value: :app
set :delayed_job_roles, [:app, :background]

# Set the location of the delayed_job executable
# Can be relative to the release_path or absolute
# default value 'bin'
set :delayed_job_bin_path: 'scripts' # for rails 3.x
```

It also adds the following hook

```ruby
after 'deploy:publishing', 'restart' do
    invoke 'delayed_job:restart'
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/guides/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

capistrano3-delayed-job is maintained by [platanus](http://platan.us).

## License

Guides is © 2014 platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.

