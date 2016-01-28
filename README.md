# Fastlane::Actions::XcodeGetProductName

This is a [fastlane](https://github.com/fastlane/fastlane)-action which helps to get product name from Xcode project. You can designate scheme, target and build-configuration.

## Installation

Make sure that [fastlane](https://github.com/fastlane/fastlane) is installed.

Add this line to your application's Gemfile:

```ruby
gem 'fastlane-actions-xcode_get_product_name'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fastlane-actions-xcode_get_product_name

## Usage

In your lane:

```ruby
appName = xcode_get_product_name(
    scheme: 'Dev',
    configuration: 'Debug',
)
```
    
and you can get product name in `appName`.

e.g. In your Fastfile:

```ruby
lane :build do |options|
    version = get_build_number
    scheme = options[:scheme] || 'Dev'
    config = options[:config] || 'Debug'
    directory = 'build/'
    appName = xcode_get_product_name(
        target: scheme,
        configuration: config,
    )
    ipaName = "#{appName}##{version}(#{scheme}, #{config}).ipa"
    gym(
        scheme: scheme,
        configuration: config,
        output_directory: directory,
        output_name: ipaName,
    )
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fastlane-actions-xcode_get_product_name. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

