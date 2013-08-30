module Atheme
  class NickServ < Service

    parse :info do
      responds_with Atheme::User
    end
    
  end
end