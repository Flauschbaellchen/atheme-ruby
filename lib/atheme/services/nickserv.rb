module Atheme
  class NickServ < Service

    parse :info do
      responds_with Atheme::User

      command :name do
        match(/^Information\son\s([^\s]+)/)
      end

      command :account, as: Atheme::User do
        match(/\(account\s([^\(]+)\):/)
      end

      command :registered do
        Date.parse(match(/Registered\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/))
      end

      command :entity_id do
        match(/Entity\sID\s+:\s+([A-F0-9]+)$/)
      end

      command :vhost do
        match(/vHost\s+:\s+([^\s]+)$/)
      end

      command :real_address do
        match(/Real\saddr\s+:\s+([^\s]+)$/)
      end

      command :last_seen do
        Date.parse(match(/Last\sseen\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/))
      end

      command :user_seen do
        time = match(/User\sseen\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/)
        time && Date.parse(time)
      end

      command :nicks do
        nicks = match(/Nicks\s+:\s+([^\s]+(?:\s[^\s]+)*)$/)
        nicks && nicks.split || []
      end

      command :email do
        match(/Email\s+:\s+([^\s]+)/)
      end

      command :language do
        match(/Language\s+:\s+([\w]+)$/)
      end

      command :flags do
        flags = match(/Flags\s+:\s+(\w+(?:\s\w+)*)$/)
        flags && flags.split || []
      end

      command :protected do
        match(/has\s(enabled)\snick\sprotection/) ? true : false
      end

      command :groups do
        flags = match(/Groups\s+:\s+([^\s]+(?:\s[^\s]+)*)$/)
        flags && flags.split || []
      end
    end
  end
end