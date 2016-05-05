# Qblox

This gem was made to communicate with the quickblox API

THIS IS NOT READY. SEVERAL CALLS ARE STILL MISSING.

But you are welcome to contributing to improve the gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qblox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qblox

## Setup

You need to configure some keys. It could be done on an initializer on Rails, 
for example.

```ruby
Qblox.config do |c|
  c.account_key = '-------------'
  c.application_id = 99999
  c.auth_key = '*************'
  c.auth_secret = '**********'
end
```

AccountKey can be found on https://admin.quickblox.com/account/settings
ApplicationId, AuthKey and AuthSecret can be found on Overview of an Application
inside of Quickblox Admin site.

## Usage

```ruby
user = Qblox::User.find 123456

user.send_pvt_message(123457, 'Hello')
```

You can interact directly with the APIs using Qblox::Api Classes

## Development

If you need another call, feel free to fork, develop and contribute. We will be
glad to accept it.

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/console` for an interactive prompt that will allow you
to experiment.

Almost all of the gem are tested. Pull Requests with tests and/or documentations
are tottaly welcome too.

## Contributing

1. Fork it ( https://github.com/doghero/qblox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
