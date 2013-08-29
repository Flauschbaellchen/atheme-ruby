module Atheme
  class ChanServ < Service

    parse :info do
      responds_with Atheme::Channel

      command :name do
        match(/^Information\son\s([&#+][^:]+):$/)
      end

      command :founder, as: Atheme::User do
        match(/Founder\s+:\s+(\w+)/)
      end

      command :successor, as: Atheme::User do
        match(/Successor\s+:\s+\(none\)/) ? nil : match(/Successor\s+:\s+(\w+)/)
      end

      command :registered do
        Date.parse(match(/Registered\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/))
      end

      command :last_used do
        time = match(/Last\sused\s+:\s+(\w+ [0-9]{2} [0-9(:?)]+ [0-9]{4})/)
        time && Date.parse(time)
      end

      command :mode_lock do
        match(/Mode\slock\s+:\s+([-+A-Za-z0-9]*)/)
      end

      command :entry_msg do
        match(/Entrymsg\s+:\s+(.+)/)
      end

      command :flags do
        flags = match(/Flags\s+:\s+(\w+(?:\s\w+)*)$/)
        flags && flags.split || []
      end

      command :prefix do
        match(/Prefix\s+:\s+([^\s])/)
      end
    end

    parse :list do
      command :to_a do
        output = raw_output.split("\n")
        output.delete_at(0)
        output.delete_at(output.length - 1)

        output.map do |info|
          out = info.sub('- ', '').split('(')
          channel = out[0].sub(' ', '')
          owner = out[1].sub(')', '').sub(' ', '')

          { channel: channel, owner: owner }
        end
      end
    end
  end
end