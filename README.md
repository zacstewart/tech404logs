# Tech404logs

[![Build Status](https://travis-ci.org/zacstewart/tech404logs.svg?branch=master)](https://travis-ci.org/zacstewart/tech404logs)

This robot indexes channels on [tech404](http://tech404.io). Simply invite
`@indexbot` to your channel to add it to the index. It listens in the channel
and logs messages in real time, so it cannot index past content.

## Usage

You need the following environment variables defined:

* `DATABASE_URL`: A PostgreSQL database URL, e.g. `postgres://localhost/tech404logs`
* `SLACK_TOKEN`: Crate a bot integration and store the token in this variable.
* `HOME_CHANNEL`: The main channel, which will be shown at the root path. Do not
  include the # hash mark. Usually "general."
* `WEB_DOMAIN`: The domain and port (if other than 80) that the web app is
  accessible on. This is used to redirect requests to non-canonical domains.
  (e.g. to the herokuapp.com domain rather than your own domain). In
  development it may be `localhost:5000`.

Run the indexing robot:

    $ bin/chatbot

Run the web server:

    $ rackup

Or run them both with Foreman:

    $ foreman start

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zacstewart/tech404logs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
