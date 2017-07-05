# Zendesk Polly

Too shy to record your own voice for __Zendesk Talk__ greetings? How about letting someone else read your text?
__ZendeskPolly__ uses __Amazon Polly__ text-to-speech engine to convert your text messages into audio files.

This gem is far from being production ready. As of now, it's just a spike to get to know a bit of Zendesk's API.


## Installation

Install the gem and use the command line:

```bash
$ gem install zendesk_polly
```

Or add this line to your application's Gemfile:

```ruby
gem 'zendesk_polly'
```

And then provide ZendeskPolly with the required credentials and account details:

```bash
$ zp init
```
This command will start an interactive shell session and will save your credentials at `~/.zendesk_polly`.

## Usage

```
$ zp --help

NAME:

  ZendeskPolly

DESCRIPTION:

  Client to create zendesk greetings with Aws Polly

COMMANDS:
      
  categories Lists available greeting categories              
  create     Creates a Zendesk greeting with Aws Polly                
  help       Display global or [command] help documentation           
  init       Configures ZendeskPolly          
  voices     Lists available voices
```


## Usage

Most commands have interactive mode, but can be initialized with some options.
Use `zp [command] --help` for details.

# Examples

```bash
# creating an IVR greeting
$ zp create --name 'My new greeting' --category 'ivr' --voice 'Joanna' --text 'This will be read by Joanna'

# or just 
$ zp create
```

You can also use ZendeskPolly's client inside your own application.

```ruby
client = ZendeskPolly::Client.new do |c|
  c.aws_region         = ... # defaults to 'us-east-1'
  c.zendesk_token      = ... # create an API token at `[your_zd_url]agent/admin/api/settings`
  c.zendesk_username   = ... # your email
  c.zendesk_url        = ... # https://{your_zd_portal}.zendesk.com/api/v2
  c.aws_key            = ... # Create an AMI user and grant access to Polly services
  c.aws_secret         = ...
end

# This won't create the greeting just yet. You have a change to listen to it before submitting to Zendesk.
greeting = client.polly_greeting.new(name: 'greeting name', text: "I've just initialized a voice message")

# Opens your default player and plays the converted audio file
greeting.play 

# To submit to zendesk use:
greeting.save

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/angelim/zendesk_polly.

