# Sidekiq::Running

Small extension to Sidekiq that allows you to see if a job is queued or running.

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq-running'

And then execute:

    $ bundle

## Usage

Include ``Sidekiq::Running`` in your worker, like this:
```ruby
class HardWorker
  include Sidekiq::Worker
  include Sidekiq::Running
  def perform(name, count)
    # do something
  end
end
```

Now, you can run
```ruby
HardWorker.queued?("buy dr.pepper", 10) # => false
HardWorker.perform_async("buy dr.pepper", 10)
HardWorker.queued?("buy dr.pepper", 10) # => true

HardWorker.perform_in(10.minutes, "whatever")
HardWorker.scheduled?("whatever") # => 2014-10-08 15:46:20 UTC
HardWorker.scheduled?("this is not scheduled") # => false

HardWorker.running?("buy dr.pepper", 10) # => true
HardWorker.running?("this is not running") # => false

# programmed is queued or scheduled
HardWorker.programmed?("whatever") # => 2014-10-08 15:46:20 UTC
HardWorker.programmed?("buy dr.pepper", 10) # => true
```

## Methods Available
``Sidekiq::Running`` adds the following class methods to your sidekiq workers:

- running?(*args)
- queued?(*args)
- scheduled?(*args)

- running_or_queued?(*args)
- running_or_programmed?(*args)

- perform_async_unless_running(*args)
- perform_async_unless_queued(*args)
- perform_async_unless_scheduled(*args)
- perform_async_unless_programmed(*args)
- perform_async_unless_running_or_queued(*args)
- perform_async_unless_running_or_programmed(*args)
- queue_name

## Contributing

1. Fork it ( https://github.com/eljojo/sidekiq-running/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
