# Araignee

Simple library with small building blocks for building great Ruby apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'araignee'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install araignee

## Usage
You can require 'araignee' to load all gem's files or require specific part of it.

```ruby
require 'araignee'
require 'araignee/ai'
require 'araignee/arquitecture'
require 'araignee/utils'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code Conduct
To build great apps we need great clean code. Code coverade must be 100% and mutant testing should be above 90%. Also make sure you Rubocop with at least these cops: `rubocop --only Lint,Layout,Performance,Style lib/araignee/`

## TODO

araignee/ai/core
 - implement mapper node
 - implement blackboard in nodes to remove node state so a behavior can be shared amongst entities.
 - implement semaphore guard.
 - implement pickers by ability, probability, reliability, repetition.
 - implement repeater by cycle.
 - implement sorter by priority.

araignee/ai/behaving
 - implement concepts such as goal, plan, behavior, strategy

araignee/ai/learning

araignee/ai/memorizing

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brupla6126/maia/araignee.

