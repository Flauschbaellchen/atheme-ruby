require "xmlrpc/client"

Dir[File.expand_path('../atheme/**/*.rb', __FILE__)].each { |file|
  require file
}

module Atheme
end
