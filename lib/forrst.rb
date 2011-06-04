require 'oauth2'
require 'json'

require File.expand_path('../forrst/version', __FILE__)

##
# The Forrst gem is an API library for the Forrst API that focuses on stability, ease of
# use and minimal dependencies.
# 
# @author Yorick Peterse
# @since  0.1a
#
module Forrst
  ##
  # The URL to the API endpoint.
  #
  # @author Yorick Peterse
  # @since  0.1a
  #
  Endpoint = 'http://forrst.com/api/v2/'

  class << self
    # The access token returned once a client has been authorized.
    attr_accessor :access_token

    # The ID of the application as provided by Forrst.
    attr_accessor :id

    # The secret of the application as provided by Forrst.
    attr_accessor :secret

    ##
    # Sets various configuration options in the module so that they can be used by other
    # parts of this gem.
    #
    # @example
    #  Forrst.configure do |client|
    #    client.access_token = '1234abc'
    #  end
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @yield  self
    #
    def configure
      yield self
    end
  end # class << self
end # Forrst
