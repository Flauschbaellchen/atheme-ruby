module Atheme
  PARSERS = Hash.new
  TMP_COMMANDS = []

  class Service
    attr_reader :raw_output

    def self.inherited(klass)
      class_name = klass.name.gsub('Atheme::', '')
      Atheme::Client.class_eval <<-RUBY
        def #{class_name.downcase}
          @#{class_name.downcase} ||= #{klass.name}.new(self)
        end
      RUBY

      Atheme::PARSERS[class_name.downcase] ||= Hash.new
    end

    def self.parse(cmd, &block)
      Atheme::TMP_COMMANDS.clear
      service = self.name.sub('Atheme::', '').downcase
      yield if block_given?
      Atheme::TMP_COMMANDS.each do |subcmd, block|
        puts "Register #{service} > #{cmd} > #{subcmd}"
        Atheme::PARSERS[service][cmd] ||= Hash.new
        Atheme::PARSERS[service][cmd][subcmd] = block
      end
    end

    def self.command(name, &block)
      Atheme::TMP_COMMANDS << [name.to_sym, block]
    end

    def initialize(client)
      @client = client
    end

    def method_missing(method, *args, &block)
      raise Atheme::Error::InvalidUser, 'No user has been set. Please login first.' unless @client.logged_in?

      @raw_output = @client.service_call(service_name, method, *args)
      build_response_object method
    end

    def build_response_object(method)
      response = {raw_output: raw_output}
      if Atheme::PARSERS.has_key?(service_name) && Atheme::PARSERS[service_name].has_key?(method)
        response.merge! Atheme::PARSERS[service_name][method]
      end
      Atheme::ServiceReply.new(response)
    end

    private

    def service_name
      self.class.name.gsub('Atheme::', '').downcase
    end
  end
end

Dir[File.expand_path('../services/*.rb', __FILE__)].each { |file|
  require file
}