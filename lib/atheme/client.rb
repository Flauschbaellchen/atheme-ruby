module Atheme
  class Client

    DEFAULT_CONNECTION_SETTINGS = {
      protocol: 'http',
      hostname: 'localhost',
      port: '8080'
    }

    def initialize(opts={})
      opts.each_key do |k|
        if self.respond_to?("#{k}=")
          self.send("#{k}=", opts[k])
        else
          raise ArgumentError, "Argument '#{k}' is not allowed"
        end
      end

      yield self if block_given?
    end

    def login(user, password, ip="127.0.0.1")
      return true unless logged_in?
      @cookie = self.call("atheme.login", user, password, ip)
      @user, @ip = user, ip
    end

    def logout
      return true unless logged_in?
      self.call("atheme.logout", @cookie, @user, @ip)
      @cookie, @user, @ip = nil
    end

    def logged_in?
      @cookie ? true : false
    end

    def call(*args)
      @server ||= connect_client
      @server.call(*args)
    end

    def protocol=(p)
      @protocol = p
    end

    def hostname=(h)
      @hostname = h
    end

    def port=(p)
      @port = p.to_i
    end

    def protocol
      @protocol || DEFAULT_CONNECTION_SETTINGS[:protocol]
    end

    def hostname
      @hostname || DEFAULT_CONNECTION_SETTINGS[:hostname]
    end

    def port
      @port || DEFAULT_CONNECTION_SETTINGS[:port]
    end

    private

    def connect_client
      @server = XMLRPC::Client.new2("#{self.protocol}://#{self.hostname}:#{self.port}/xmlrpc")
    end
  end
end