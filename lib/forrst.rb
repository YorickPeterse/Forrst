require 'rubygems'
require 'oauth2'
require 'json'
require 'date'

['version', 'monkeys/hash', 'user', 'post', 'comment'].each do |file|
  require File.expand_path("../forrst/#{file}", __FILE__)
end

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
  URL = 'http://forrst.com/api/v2/'

  ##
  # URL relative to Forrst::URL that contains all the API statistics.
  #
  # @author Yorick Peterse
  # @since  0.1a
  #
  StatisticsURL = '/stats'

  ##
  # A string containing the date format used for all dates returned by the API.
  #
  # @author Yorick Peterse
  # @since  0.1a
  #
  DateFormat = '%Y-%m-%d %H:%M:%S'

  class << self
    # The access token returned once a client has been authorized.
    attr_accessor :access_token

    # The ID of the application as provided by Forrst.
    attr_accessor :id

    # The secret of the application as provided by Forrst.
    attr_accessor :secret

    # Instance of OAuth2::Client.
    attr_accessor :oauth

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

      @oauth = OAuth2::Client.new(@id, @secret, :site => URL)
    end

    ##
    # Gets a set of statistics from the API server.
    #
    # @example
    #  stats = Forrst.statistics
    #  stats[:limit] # => 150
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @return [Hash]
    #
    def statistics
      response = @oauth.request(:get, StatisticsURL)
      response = JSON.load(response)
      hash     = {
        :limit => response['resp']['rate_limit'].to_i,
        :calls => response['resp']['calls_made'].to_i
      }
    
      return hash
    end
  end # class << self
end # Forrst
