module Atheme
  class ChanServ < Service

    parse :info do
      responds_with Atheme::Channel
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