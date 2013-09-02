module Atheme
  class Session

    # Connection settings which are used on default
    DEFAULT_CONNECTION_SETTINGS = {
      protocol: 'http',
      hostname: 'localhost',
      port: '8080'
    }
    # Default IP for connections if noone is specified on login
    DEFAULT_IP = '127.0.0.1'

    def initialize(opts={})
      opts.each_key do |k|
        if self.respond_to?("#{k}=")
          self.send("#{k}=", opts[k])
        else
          raise ArgumentError, "Argument '#{k}' is not allowed"
        end
      end

      yield self if block_given?
      @cookie, @user, @ip = '.', '.', DEFAULT_IP
    end

    # Login with an username and passwortd into atheme.
    # The creditials are the same as in IRC.
    # IP is optional and only for logging purposes, defaults to 127.0.0.1.
    # Returns a cookie on success, an Atheme::Error otherwise
    def login(user, password, ip=DEFAULT_IP)
      cookie_or_error = self.call("atheme.login", user, password, ip)
      if cookie_or_error.kind_of?(String)
        @cookie, @user, @ip = cookie_or_error, user, ip
      else # should be Atheme::Error
        @cookie, @user, @ip = '.', '.', DEFAULT_IP
      end
      return cookie_or_error
    end

    # Relogin into the services using a previously created cookie
    # and the associated username.
    def relogin(cookie, user, ip=DEFAULT_IP)
      @cookie, @user, @ip = cookie, user, ip
      logged_in?
    end

    # Logs out from the current session if previously logged in.
    # Always returns true
    def logout
      return true unless logged_in?
      self.call("atheme.logout", @cookie, @user, @ip)
      @cookie, @user, @ip = '.', '.', DEFAULT_IP
      true
    end

    # Returns true if we are currently logged in and the cookie is a valid one; false otherwise.
    def logged_in?
      return false if @cookie.nil? || @cookie=='.'
      #need to call a dummy command to decide if the cookie is still valid
      #as we think that we are a valid user, /ns info 'self' should succeed
      self.nickserv.info(@user).success?
    end

    # Returns an Atheme::User object of the current user who is logged in
    # Returns false, if noone is currently logged in
    def myself
      return false unless logged_in?
      self.nickserv.info(@user)
    end

    # Send raw XMLRPC calls to the Atheme API
    def call(*args)
      @server ||= connect_client
      return @server.call(*args)
    rescue
      return Atheme::Error.new
    end

    # Shorthand method for service-calls through the Atheme API
    def service_call(service, method, *args)
      self.call("atheme.command", @cookie, @user, @ip, service, method, *args)
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