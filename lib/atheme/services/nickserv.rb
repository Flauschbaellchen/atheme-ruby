module Atheme
  class NickServ < Service

    # Returns an Atheme::User entity which holds all information about the requested user
    def info(name)
      Atheme::User.new(session, name)
    end
    
  end
end