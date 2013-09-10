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
        @session = session
        value = self.instance_eval(&@block)
        return value if !@opts[:as] || value.nil?
        @opts[:as].new(@session, value)
      end

      private
      def raw_output
        @raw_output
      end

      def session
        @session
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

    def self.responds_with(atheme_class=nil, &block)
      @@staged_parser.responder = atheme_class || block
    end

    def initialize(session)
      @session = session
    end

    def method_missing(method, *args, &block)
      raw_output = @session.service_call(service_name, method, *args)
      
      #if an error occurred, just return it to the user
      return raw_output if raw_output.kind_of?(Atheme::Error)

      #building up the response hash...
      response = {raw_output: raw_output}

      #get the parser of the method registered with 'parse :key'
      parser = @@parsers.has_key?(service_name) && @@parsers[service_name][method]

      #no parser is available, return generic Entity which holds only the raw_output
      return Atheme::Entity.new(@session, response, &block) unless parser

      #a responds_with is defined and associates a block
      #we do not need any further command-handling
      #as we only serve the raw_output if the request
      return parser.responder.call(@session, response[:raw_output]) if parser.responder && parser.responder.kind_of?(Proc)

      #add further commands/key-values to the hash registered with 'command :key'
      parser.commands.each do |command|
        response[command.name] = command.call(@session, raw_output)
      end
      
      #create a special Entity registered with resonds_with if available
      return parser.responder.new(@session, response, &block) if parser.responder

      #last but not least, return a generic Entity but with extended commands/values
      return Atheme::Entity.new(@session, response, &block)
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