atheme-ruby
===========
The gem was inspired by the one of [jameswritescode/atheme-ruby](https://github.com/jameswritescode/atheme-ruby/).
However, his gem use module-methods and thus does not allow concurrent connections within the same script.

Install
-------

Currently, no official gem yet exists, so you need to clone the repository and build it yourself:

    git clone git@github.com:Flauschbaellchen/atheme-ruby.git
    cd atheme-ruby
    gem build atheme-ruby.gemspec
    gem install atheme-ruby-x.x.x.gem

Usage
-----

Standalone script:

    require 'atheme'

Bundler/Rails:

    gem 'atheme-ruby', require: 'atheme'

And you're ready to rumble!

To instantiate, you can either pass the required arguments as options in a
hash, like so:

    Atheme::Client.new(
      protocol: "http",
      hostname: "localhost",
      port: 8080
    )

and/or use the builder idiom:

    Atheme::Client.new do |c| 
      c.protocol = "http"
      c.hostname = "localhost"
      c.port = 8080
    end

If an option is missing, the default ones as stated above are used.

After you initialized an Atheme::Client object, e.g. @client, you need to login to perform and send any commands.

    @client.login(username, password, ip="127.0.0.1") #=> true on success
    @client.logged_in? #=> true or false

You may logout after you finished your work:

    @client.logout

This gem supports all service-bots of atheme, like chanser, nickserv etc.
You can call any commands you want to perform like you do on IRC:

    @client.chanserv.info('#opers') # like /msg chanserv info #opers
    @client.chanserv.list           # like /msg chanserv list

I think you're getting the point...
However, you can perform additional questions on these return values:

    @client.chanserv.info('#opers').founder    #=> "FounderNickOfOpers"
    @client.chanserv.info('#opers').registered #=> #<DateTime "2013-05-07 00:00:00 +0200">

Take a look into _lib/atheme/services/*_ to find available subcommands.

TODO
----
* Tests!
* Add more parsers/subcommands to all kinds of services (pull requests welcome)
* Return objects instead of strings on subcommands where useful. E.g. #<Atheme::User> object on _@client.chanserv.info('#opers').founder_.
  Then it would be much easier to do additional lookups like _@client.chanserv.info('#opers').founder.registered_
* Brainstorming: Catch API-Errors and handle them gracefully. Provide a #success? method to decide if the command was successfully executed or not. Need to handle chains like the ones above.

Contributing to atheme-ruby
---------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2013 Noxx/Flauschbaellchen. See LICENSE for further details.

