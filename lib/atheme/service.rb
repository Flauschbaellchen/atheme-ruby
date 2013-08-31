module Atheme
  class Service
    @@parsers = Hash.new
    @@tmp_commands = []
    @@tmp_class = nil

    class Parser
      attr_accessor :responder
      attr_reader :commands

      def initialize
        @commands = []
      end

      def register_command(command)
        @commands << command
      end
    end

    class Command
      attr_reader :name, :block

      def initialize(name, opts, &block)
        @name = name
        @block = block
        @opts = opts
      end

      def call(session, raw_output)
        @raw_output = raw_output
        value = self.instance_eval(&@block)
        return value if !@opts[:as] || value.nil?
        @opts[:as].new(session, value)
      end

      private
      def raw_output
        @raw_output
      end

      def match(expression)
        raw_output[expression, 1]
      end
    end


    def self.inherited(klass)
      class_name = klass.name.gsub('Atheme::', '')
      Atheme::Session.class_eval <<-RUBY
        def #{class_name.downcase}
          @#{class_name.downcase} ||= #{klass.name}.new(self)
        end
      RUBY

      @@parsers[class_name.downcase] ||= Hash.new
    end

    def self.parse(cmd, &block)
      service = self.name.sub('Atheme::', '').downcase
      @@parsers[service][cmd] = Atheme::Service::Parser.new
      @@staged_parser = @@parsers[service][cmd]
      yield if block_given?
    end

    def self.command(name, opts={}, &block)
      @@staged_parser.register_command(Atheme::Service::Command.new(name, opts, &block))
    end

    def self.responds_with(atheme_class)
      @@staged_parser.responder = atheme_class
    end

    def initialize(session)
      @session = session
    end

    def method_missing(method, *args, &block)
      raw_output = @session.service_call(service_name, method, *args)
      if raw_output.kind_of?(Atheme::Error)
        return raw_output
      end
      response = {raw_output: raw_output}
      parser = @@parsers.has_key?(service_name) && @@parsers[service_name][method]

      return Atheme::Entity.new(@session, response, &block) unless parser
      
      parser.commands.each do |command|
        response[command.name] = command.call(@session, raw_output)
      end
      return parser.responder.new(@session, response, &block) if parser.responder
      return response
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