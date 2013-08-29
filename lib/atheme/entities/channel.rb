module Atheme
  class Channel < Entity

    def fetch! #:nodoc:
      @session.chanserv.info(@token)
    end

    # Forcefully removes the channel, including
    # all data associated with it (like access lists etc)
    # and cannot be restored.
    # Only opers may use this.
    def fdrop!
      @session.chanserv.fdrop(self.name)
    end

    # close! prevents a channel from being used. Anyone
    # who enters is immediately kickbanned. The channel
    # cannot be dropped and foundership cannot be
    # transferred.
    # 
    # On executing this method, it will immediately kick all
    # users from the channel.
    # 
    # Use unclose!/open! to reopen a channel. While closed,
    # channels will still expire.
    # 
    # Only opers may use this.
    def close!(reason)
      @session.chanserv.close(self.name, :on, reason)
    end

    # Opens a previously closed channel.
    # 
    # Only opers may use this.
    def open!
      @session.chanserv.close(self.name, :off)
    end
    alias_method :unclose!, :open!

    # Gives someone channel admin/protection (+a) permissions
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def protect(nick)
      change_permissions(:protect, nick)
    end
    alias_method :admin, :protect

    # Takes channel operator (-a) permissions from someone.
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def deprotect(nick)
      change_permissions(:deprotect, nick)
    end
    alias_method :deadmin, :deprotect

    # Gives someone channel operator (+o) permissions
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def op(nick)
      change_permissions(:op, nick)
    end

    # Takes channel operator (-o) permissions from someone.
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def deop(nick)
      change_permissions(:deop, nick)
    end

    # Gives someone channel halfop (+h).
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def halfop(nick)
      change_permissions(:halfop, nick)
    end

    # Takes channel halpop (-h) from someone.
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def dehalfop(nick)
      change_permissions(:dehalfop, nick)
    end

    # Gives someone channel voice (+v).
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def voice(nick)
      change_permissions(:voice, nick)
    end

    # Takes channel voice (-v) from someone.
    # If the nick is omitted the action is performed
    # on the person requesting the command.
    # Nick can be a single user or an array of users (as strings or Atheme::Users).
    def devoice(nick)
      change_permissions(:devoice, nick)
    end

    # mark! allows operators to attach a note to a channel.
    # For example, an operator could mark the channel to be a botnet channel.
    def mark!(reason)
      @session.chanserv.mark(self.name, :on, reason)
    end

    # Unmark a previously marked channel.
    def unmark!
      @session.chanserv.mark(self.name, :off)
    end

    # Allows you to regain control of your
    # channel in the event of a takeover.
    #  
    # More precisely, everyone will be deopped,
    # limit and key will be cleared, all bans
    # matching you are removed, a ban exception
    # matching you is added (in case of bans Atheme
    # can't see), the channel is set invite-only
    # and moderated and you are invited.
    #  
    # If you are on channel, you will be opped and
    # no ban exception will be added.
    def recover!
      @session.chanserv.recover(self.name)
    end

    # Allows you to ban a user or hostmask from a channel.
    def ban!(nick_or_host)
      @session.chanserv.ban(self.name, nick_or_host)
    end

    # Allows you to unban a user or hostmask from a channel.
    def unban!(nick_or_host)
      @session.chanserv.unban(self.name, nick_or_host)
    end

    # The KICK command allows for the removal of a user from
    # a channel. The user can immediately rejoin.
    # 
    # Your nick will be added to the kick reason.
    # The reason is optional./cs 
    def kick!(reason=nil)
      reason.kind_of?(String) ? @session.chanserv.kick(self.name, nick) : @session.chanserv.kick(self.name, nick, reason)
    end

    # Sets a topic on the channel.
    def topic!(topic)
      @session.chanserv.topic(self.name, topic)
    end

    # Prepends something to the topic on the channel.
    def prepend_topic!(topic)
      @session.chanserv.topicprepend(self.name, topic)
    end

    private
    def change_permissions(perm, nick=nil)
      case
        when nick.kind_of?(String)
          @session.chanserv.send(perm, self.name, nick)
        when nick.kind_of?(Atheme::User)
          @session.chanserv.send(perm, self.name, nick.name)
        when nick.kind_of?(Array)
          nick.each do |n|
            change_permissions(perm, self.name, n)
          end
      end
    end

  end
end