module Atheme
  class User < EntityBase

    def fetch! #:nodoc:
      @session.nickserv.info(@token)
    end

    # Forcefully removes the account, including
    # all nicknames, channel access and memos attached to it.
    # Only opers may use this.
    def fdrop!
      @session.nickserv.fdrop(self.name)
    end

    # freeze! allows operators to "freeze" an abusive user's
    # account. This logs out all sessions logged in to the
    # account and prevents further logins. Thus, users
    # cannot obtain the access associated with the account.
    def freeze!(reason)
      @session.nickserv.freeze(self.name, :on, reason)
    end

    # Unfreeze an previously frozen account.
    def unfreeze!
      @session.nickserv.freeze(self.name, :off)
    end

    # mark! allows operators to attach a note to an account.
    # For example, an operator could mark the account of
    # a spammer so that others know the user has previously
    # been warned.
    def mark!(reason)
      @session.nickserv.mark(self.name, :on, reason)
    end

    # Unmark a previously marked account.
    def unmark!
      @session.nickserv.mark(self.name, :off)
    end

    # vhost! allows operators to set a virtual host (also
    # known as a spoof or cloak) on an account. This vhost
    # will be set on the user immediately and each time
    # they identify
    def set_vhost!(vhost)
      @session.nickserv.vhost(self.name, :on, vhost)
    end

    # Removes a previously added vhost from the account
    def remove_vhost!
      @session.nickserv.vhost(self.name, :off)
    end

    # Sets a random password for this account.
    # Only opers may use this.
    def reset_password!
      @session.nickserv.resetpass(self.name)
    end
  end
end