[![Gem Version](https://badge.fury.io/rb/atheme-ruby.png)](http://badge.fury.io/rb/atheme-ruby) [![Dependency Status](https://gemnasium.com/Flauschbaellchen/atheme-ruby.png)](https://gemnasium.com/Flauschbaellchen/atheme-ruby)

# atheme-ruby
The gem was inspired by [jameswritescode/atheme-ruby](https://github.com/jameswritescode/atheme-ruby/).
However, his gem use module-methods and thus does not allow concurrent connections within the same script.

## Install

You can install the gem directly from rubygems.org:

    gem install atheme-ruby

Standalone script:

    require 'atheme'

Bundler/Rails:

    gem 'atheme-ruby', require: 'atheme'

And you're ready to rumble!

## Usage

To instantiate, you can either pass the required arguments as options in a
hash, like so:

    Atheme::Session.new(
      protocol: "http",
      hostname: "localhost",
      port: 8080
    )

and/or use the builder idiom:

    Atheme::Session.new do |c| 
      c.protocol = "http"
      c.hostname = "localhost"
      c.port = 8080
    end

If an option is missing, the default ones as stated above are used.

### Login

The initial session uses an anonymous login which can be re-choosen by  logging out.

To login with an account registered with NickServ use the following:

    @session.login(username, password, ip="127.0.0.1") #=> you'll get a cookie on success
    @session.logged_in? #=> true or false

The cookie is a random generated string from Atheme for your current login session and will be valid for one(1) hour or until the server is shut down or restarted.

You can relogin using the cookie by calling:

    @session.relogin(cookie, user, ip="127.0.0.1")

which saves you from asking users everytime again for their passwords.

You may logout after you finished your work:

    @session.logout

### Service-Calls

This gem supports all service-bots of atheme, like chanserv, nickserv etc.
You can call any commands you want to perform like you do on IRC; Each param goes into a different argument of the method:

    @session.chanserv.info('#opers')                     # /msg chanserv info #opers
    @session.chanserv.list                               # /msg chanserv list
    @session.nickserv.mark("Nick", "ON", "marking Nick") # Marks Nick with a note

I think you're getting the point...
However, you can perform additional questions on these return values:

    @session.chanserv.info('#opers').founder             #=> #<Atheme::User ...>
    @session.chanserv.info('#opers').founder.name        #=> "Nick_Of_Founder"
    @session.chanserv.info('#opers').registered          #=> #<Date: 2013-05-13 ((2456426j,0s,0n),+0s,2299161j)>
    @session.nickserv.info("Nick").mark!("marking Nick") #=> Marks an user

Or a bit simplier if you want to run multiple ones on one User/Channel/...

    @session.nickserv.info("Nick") do |n|
      n.mark!("marking...")
      n.set_vhost!("omg.that.is.awesome")
      n.reset_password!
    end

Take a look into _lib/atheme/services/*_ and _lib/atheme/entities/*_ to find available subcommands.
The commands which call the API return a Atheme::Entity or a subclass like Atheme::User or Atheme::Channel etc. You can call #raw_output on these to get the raw service reply of the command you called.

TODO
----
* Tests!
* Docs!
* Add more parsers/subcommands to all kinds of services (pull requests welcome)
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

