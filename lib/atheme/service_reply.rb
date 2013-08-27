module Atheme
  class ServiceReply
    def initialize(hash)
      hash.each do |k, v|
        v = self.instance_eval(&v) if v.kind_of? Proc
        define_singleton_method k, -> {v}
      end
    end

    private

    def match(expression)
      ematch = expression.match(raw_output)
      ematch && ematch[1]
    end

  end
end