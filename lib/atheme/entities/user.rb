module Atheme
  class User < EntityBase

    def update! #:nodoc:
      @raw = @session.service_call("nickserv", "info", @token)
    end

    # Returns the nickname (not account name) of the user
    def name
      match(/^Information\son\s([^\s]+)/)
    end

    # Returns the account name of the user as an Atheme::User object
    def account
      Atheme::User.new(@session, match(/\(account\s([^\(]+)\):/))
    end

    # Date object which is set to the time when the nick was registered
    def registered
      Date.parse(match(/Registered\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/))
    end

    # Unique entity ID. Available only if the user is currently connected
    def entity_id
      match(/Entity\sID\s+:\s+([A-F0-9]+)$/)
    end

    # Returns the vhost of the nick if set
    def vhost
      match(/vHost\s+:\s+([^\s]+)$/)
    end

    # Real address of the user's connection
    def real_address
      match(/Real\saddr\s+:\s+([^\s]+)$/)
    end

    # Date object of the time when the nick was last seen
    def last_seen
      return Time.now.to_date if match(/Last\sseen\s+:\s(now)/)
      Date.parse(match(/Last\sseen\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/)) rescue nil
    end

    # Date object of the time when the user was last seen
    def user_seen
      Date.parse(match(/User\sseen\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/)) rescue nil
    end

    # Returns an array of linked nicknames to this nick/account
    def nicks
      match(/Nicks\s+:\s+([^\s]+(?:\s[^\s]+)*)$/).split rescue []
    end

    # Returns the user's email
    def email
      match(/Email\s+:\s+([^\s]+)/)
    end

    # Returns the user's language
    def language
      match(/Language\s+:\s+([\w]+)$/)
    end

    # Returns the user's flags as an array, e.g. HideMail
    def flags
      match(/Flags\s+:\s+(.+)$/).split rescue []
    end

    # Returns true if the user enabled nick protection, false otherwise
    def protected
      match(/has\s(enabled)\snick\sprotection/) ? true : false
    end
    alias_method :protected?, :protected

    # Returns the user's groups as an array,
    def groups
      match(/Groups\s+:\s+(.+)$/).split rescue []
    end

    # Forcefully removes the account, including
    # all nicknames, channel access and memos attached to it.
    # Only opers may use this.
    def fdrop!
      @session.nickserv.fdrop(self.name)
    end

    # freeze allows operators to "freeze" an abusive user's
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

    # mark allows operators to attach a note to an account.
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

    # vhost allows operators to set a virtual host (also
    # known as a spoof or cloak) on an account. This vhost
    # will be set on the user immediately and each time
    # they identify
    # If no vhost is given, the current one will be deleted.
    def vhost!(vhost=nil)
      vhost.nil? ? remove_vhost! : @session.nickserv.vhost(self.name, :on, vhost)
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