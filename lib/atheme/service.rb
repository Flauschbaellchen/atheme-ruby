module Atheme
  class Service
    @@parsers = Hash.new

    def self.inherited(klass)
      class_name = klass.name.gsub('Atheme::', '')
      Atheme::Session.class_eval <<-RUBY
        def #{class_name.downcase}
          @#{class_name.downcase} ||= #{klass.name}.new(self)
        end
      RUBY

      @@parsers[class_name.downcase] ||= Hash.new
    end

    def initialize(session)
      @session = session
    end

    def method_missing(method, *args, &block)
      raw_output = call(method, *args)
      #if an error occurred, just return it to the user
      return raw_output if raw_output.kind_of?(Atheme::Error)
      #return generic entity as we couldn't handle it ourself
      return Atheme::Entity.new(session, {raw_output: raw_output}, &block)
    end

    private
    def service_name
      self.class.name.gsub('Atheme::', '').downcase
    end

    def call(method, *args)
      raw_output = session.service_call(service_name, method, *args)
      return raw_output if raw_output.kind_of?(Atheme::Error)
      block_given? ? yield(raw_output) : raw_output
    end

    def session
      @session
    end
  end
end

Dir[File.expand_path('../services/*.rb', __FILE__)].each { |file|
  require file
}