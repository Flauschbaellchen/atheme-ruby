module Atheme
  class Channel < Entity
    def fetch!
      @session.chanserv.info(@token)
    end
  end
end