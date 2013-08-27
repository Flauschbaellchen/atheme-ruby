module Atheme
  class User < EntityBase
    def fetch!
      @session.nickserv.info(@token)
    end
  end
end