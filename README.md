# Brancher

[![Build Status](https://travis-ci.org/naoty/brancher.svg)](https://travis-ci.org/naoty/brancher)
[![Code Climate](https://codeclimate.com/github/naoty/brancher/badges/gpa.svg)](https://codeclimate.com/github/naoty/brancher)

Brancher is a rubygem to switch databases connected with ActiveRecord by Git branch.

For example, if the name of a database is `sample_app_dev`, Brancher will switch the database to `sample_app_dev_master` at `master` branch, and `sample_app_dev_some_feature` at `some_feature` branch.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "brancher"
end
```

And then execute:

```
$ bundle
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/brancher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

[naoty](https://github.com/naoty)
