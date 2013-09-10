module Atheme::Helpers
  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object

    names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end

    constant
  end

  class List < Array

    def method_missing(method, *args, &block)
      method = method.to_s.singularize.to_sym
      return self.map {|v| v[method] }.flatten if self.first.has_key? method
      super
    end

  end
end