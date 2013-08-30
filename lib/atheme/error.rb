module Atheme
  class Error
    attr_reader :error, :skipped_methods

    def initialize(error=nil)
      @error = error || $!
      @skipped_methods = []
    end

    def success?
      false
    end

    def error?
      true
    end

    def method_missing(meth, *args, &block)
      @skipped_methods << [meth, args, block]
      self
    end
  end
end