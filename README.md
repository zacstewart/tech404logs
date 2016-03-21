# Tech404logs

This robot indexes channels on [tech404](http://tech404.io). Simply invite
`@indexbot` to your channel to add it to the index. It listens in the channel
and logs messages in real time, so it cannot index past content.


## Installation

    $ gem install tech404-index


## Usage

You need to have a database created and put in the `DATABASE_URL` environment
variable. you also need a Slack API token. Create a bot integration, and put
the token in the `SLACK_TOKEN` environment variable.

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
