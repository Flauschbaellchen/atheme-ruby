module Atheme
  class NickServ < Service

    parse :info do

      command :account do
        match(/\(account\s([^\(]+)\):/)
      end

      command :registered do
        Date.parse(match(/Registered\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/)).to_time
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
        Date.parse(match(/Last\sseen\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/)).to_time
      end

      command :user_seen do
        Date.parse(match(/User\sseen\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/)).to_time
      end

      command :nicks do
        match(/Nicks\s+:\s+(\w+(?:[^\s]+)*)$/).split
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

      command :protected? do
        match(/has\s(enabled)\snick\sprotection/) ? true : false
      end

      command :groups do
        flags = match(/Groups\s+:\s+([^\s]+(?:\s[^\s]+)*)$/)
        flags && flags.split || []
      end
    end
  end
end