module Atheme
  class HostServ < Service

    # Returns an Atheme::Helpers::List
    # with {user: Atheme::User, vhost: String}
    parse :listvhost do
      responds_with do |session, raw_output|
        output = raw_output.split("\n")[0..-2]

        output.map! do |info|
          out = info.split(" ")
          {
            user: Atheme::User.new(session, out[1]),
            vhost: out[2]
          }
        end

        Atheme::Helpers::List.new(output)
      end
    end
  end
end