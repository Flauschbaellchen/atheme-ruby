module Atheme
  class ServiceReply
    def initialize(hash)
      @hash = hash
    end

    def method_missing(method, *args, &block)
      if @hash.has_key? method
        return @hash[method] unless @hash[method].kind_of? Proc
        return @hash[method] = self.instance_eval(&(@hash[method]))
      end
      super
    end

    private

    def match(expression)
      expression.match(raw_output)[1]
    end

  end
end