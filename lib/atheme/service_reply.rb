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

    def to_s
      raw_output
    end

    private

    def match(expression)
      ematch = expression.match(raw_output)
      ematch && ematch[1]
    end

  end
end