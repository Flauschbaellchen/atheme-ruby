module Atheme
  class EntityBase

    attr_reader :token
    def initialize(session, raw_or_token)
      @session = session
      @raw = nil
      if raw_or_token.kind_of?(Hash)
        @raw = raw_or_token[:raw]
      else
        @token = raw_or_token
      end

      yield self if block_given?
    end

    def self.enforce_raw_error_check_on(*methods)
      methods.each do |method|
        m = instance_method(method)
        define_method(method) do |*args, &block|
          return raw.send(method, args, block) if error?
          m.bind(self).(*args, &block)
        end
      end
    end

    def update!
      raise "#{self} does not know how to update itself. Slap the developer!"
    end

    def to_ary; end

    def error?
      !success?
    end

    def success?
      raw.kind_of?(String)
    end

    def raw
      @raw || update!
    end

    private
    def match(expression)
      raw[expression, 1]
    end

    def check_success
      return @raw if error?
      yield
    end

  end

  class Entity < EntityBase
    def update!
      @raw = ""
    end
  end
end

Dir[File.expand_path('../entities/*.rb', __FILE__)].each { |file|
  require file
}