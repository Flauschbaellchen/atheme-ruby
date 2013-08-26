atheme-ruby
===========

To instantiate, you can either pass the required arguments as options in a
hash, like so:

    Atheme::Client.new(
      :protocol=>"http",
      :hostname=>"localhost",
      :port=>1234
    )

and/or use the builder idiom:

    Atheme::Client.new do |c| 
      c.protocol = "http"
      c.hostname = "localhost"
      c.port = 1234
    end

If an option is missing the default ones as stated above are used.


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

