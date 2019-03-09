# SlippyMethodHooks

Available Hooks 

`.before` - before a method execute callback 

`.after` - after a method execute callback

`.rescue_on_fail` - if failure then rescue then call callback

`.time_box_method` - time box and call callback

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slippy_method_hooks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slippy_method_hooks

## Usage

##  `.before`
The before hook will be called before the method call
```ruby
class MyClass
  include SlippyMethodHooks
  def a(args)
    args
  end
  
  def b(args)
    args
  end

  before(:a, :b) do |name, args|
    puts name # this is the name of the method
    puts args # yields the args 
  end
end
my_class = MyClass.new
my_class.b('arg 1', 'arg 2')
# b
# ['arg 1', 'arg 2']
```
 

`.after` - after a method execute callback

`.rescue_on_fail` - if failure then rescue then call callback

`.time_box_method` - time box and call callback
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/slippy_method_hooks.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
