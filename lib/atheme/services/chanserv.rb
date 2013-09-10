module Atheme
  class ChanServ < Service

    # Returns an Atheme::Channel entity which holds all information about the requested channel
    parse :info do
      responds_with Atheme::Channel
    end

    # Returns an Atheme::Helpers::List
    # with {channel: Atheme::Channel, founder: Atheme::User}
    parse :list do
      responds_with do |session, raw_output|
        output = raw_output.split("\n")
        output.delete_at(0)
        output.delete_at(output.length - 1)

        output.map! do |info|
          out = info.sub('- ', '').split('(')
          channel = out[0].sub(' ', '')
          owner = out[1].sub(')', '').sub(' ', '')

          {
            channel: Atheme::Channel.new(session, channel),
            founder: Atheme::User.new(session, owner)
          }
        end

        Atheme::Helpers::List.new(output)
      end
    end
  end
end