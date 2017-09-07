# Himekaminize [![Build Status](https://travis-ci.org/otukutun/himekaminize.svg?branch=master)](https://travis-ci.org/otukutun/himekaminize) [![Gem Version](https://badge.fury.io/rb/himekaminize.svg)](https://badge.fury.io/rb/himekaminize)

Utilities to extract markdown some parts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'himekaminize'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install himekaminize
```

## Usage

```ruby
task_list = Himekaminize::TaskList.new("- [ ] TODO\n  - [ ] ねる\n  - [ ] おきる").call

task_list.update_task_status(1, :complete)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/himekaminize.
