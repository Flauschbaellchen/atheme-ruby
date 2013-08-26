module Atheme
  class Service
    def self.inherited(klass)
      class_name = klass.name.gsub('Atheme::', '')
      Atheme::Client.class_eval <<-RUBY
        def #{class_name.downcase}
          @#{class_name.downcase} ||= #{klass.name}.new(self)
        end
      RUBY
    end

    def initialize(client)
      @client = client
    end

    def method_missing(method, *args, &block)
      raise Atheme::Error::InvalidUser, 'No user has been set. Please login first.' unless @client.logged_in?

      service = self.class.name.gsub('Atheme::', '').downcase
      @client.service_call(service, method, *args)
    end
  end
end

Dir[File.expand_path('../services/*.rb', __FILE__)].each { |file|
  require file
}