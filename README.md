atheme-ruby
===========

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

If an option is missing the default ones as stated above are used.

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

    @client.chanserv.info('#opers').founder       #=> "FounderNickOfOpers"
    @client.chanserv.info('#opers').registered_at #=> #<DateTime "2013-05-07 00:00:00 +0200">

Take a look into _atheme/services/*_ to find available subcommands

TODO
====

* Add more parsers/subcommands to all kinds of services (pull requests welcome)
* Return objects instead of strings on subcommands where useful. E.g. #<Atheme::User> object on _@client.chanserv.info('#opers').founder_.
  Then it would be much easier to do additional lookups like _@client.chanserv.info('#opers').founder.registered_

Contributing to atheme-ruby
===========================
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=========

Copyright (c) 2013 Noxx. See LICENSE for further details.

