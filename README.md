# Clean annotations - annotate ruby methods and classes

Define annotatable attribute names and assign them to methods or classes, add callbacks to non-Rails classes. Void of dependencies.

## Installation and usage

to install

`gem install clean-annotations`

or in Gemfile

`gem 'clean-annotations'`

and to use

`require 'clean-annotations'`

### Dependency

None

## Class attributes

```
class A
  class_attribute :layout, 'default'
  class_attribute(:time) { Time.now }
end

class B < A
  layout 'main'
end

class C < B
  time '11:55'
end

for func in [:layout, :time]
  for klass in [A, B, C]
    puts "> %s = %s" % ["#{klass}.#{func}".ljust(8), klass.send(func)]
  end
end

# A.layout = default
# B.layout = main
# C.layout = main
# A.time   = 2019-10-28 18:07:33 +0100
# B.time   = 2019-10-28 18:07:33 +0100
# C.time   = 11:55
```

## Class Callbacks

```
class Foo
  define_callback :before

  before do
  end

  before :method_name
end

# instance = new
# instance.run_callback :before
# instance.run_callback :before, @arg
```

## Method attributes

```
class Foo
  method_attr :name
  method_attr :param do |field, type=String, opts={}|
    opts[:name] = field
    opts[:type] ||= String
    opts
  end
end

class Foo
  name "Test method desc 1"
  name "Test method desc 2"
  param :email, :email
  def test
    # ...
  end
end

# Foo.method_attr
# {
#   test: {
#     name: [
#       ["Test method desc 1"],
#       ["Test method desc 2"]
#     ],
#     param: [
#       {
#         name: :email,
#         type: String
#       }
#     ]
#   }
# }
```

## Rescue from

Standard Rails like `rescue_from`. You capture errors by executing in `resolve_rescue_from`

```ruby
class RescueParent
  include RescueFromError

  rescue_from :all do
    # ...
  end

  rescue_from NoMethodError do
    # ...
  end
end

class RescueTest
  def some_method
    resolve_rescue_from do
      triger_no_method_error
    end
  end
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/solnic/clean-annotations.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
