module Atheme
  class EntityBase

    attr_reader :token
    def initialize(session, hash_or_token)
      @session = session
      if hash_or_token.kind_of?(Hash)
        @updated = true
        hash_or_token.each do |k, v|
          self.instance_variable_set("@#{k}".to_sym, v)
          define_singleton_method(k) { v }
        end
      else
        @updated = false
        @token = hash_or_token
      end

      yield self if block_given?
    end

    def method_missing(meth, *args, &block)
      super if @updated || !fetchable?
      do_fetch!
      self.send(meth, *args, &block)
    end

    def fetch!
      raise "#{self} does not know how to update itself. Slap the developer!"
    end

    def error?
      false
    end

    def success?
      true
    end

    def do_fetch!
      @updated = true
      result = fetch!
      result.instance_variables.each do |key|
        next if [:@session, :@updated, :@token].include? key
        v = result.instance_variable_get(key)
        self.instance_variable_set(key, v)
        define_singleton_method(key.to_s[1..-1].to_sym) { v }
      end
    end
    
    def fetchable?
      true
    end
    private :do_fetch!, :fetchable?

    private
    def match(expression)
      raw_output[expression, 1]
    end

  end

  class Entity < EntityBase
    def fetchable?
      false
    end
  end
end

Dir[File.expand_path('../entities/*.rb', __FILE__)].each { |file|
  require file
}