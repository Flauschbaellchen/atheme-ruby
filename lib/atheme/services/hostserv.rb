module Atheme
  class HostServ < Service

    parse :listvhost do
      command :to_a do
        output = raw_output.split("\n")[0..-2]

        output.map! do |info|
          out = info.split(" ")
          { user: out[1], vhost: out[2] }
        end

        Atheme::Helpers::List.new(output)
      end
    end
  end
end