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
    ##
    # The access token returned once a client has been authorized.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_accessor :access_token

    ##
    # The ID of the application as provided by Forrst.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_accessor :id

    ##
    # The secret of the application as provided by Forrst.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_accessor :secret

    ##
    # Instance of OAuth2::Client.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_accessor :oauth

    ##
    # The user agent to use for all API calls.
    #
    # @author Yorick Peterse
    # @since  0.1.2
    #
    attr_accessor :user_agent

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
    # Sends a request to the API server using the method, URL and optionally a hash of
    # options.
    #
    # @author Yorick Peterse
    # @since  0.1.2
    # @param  [Symbol] verb The HTTP verb to use as a symbol.
    # @param  [String] url The URI relative to the main one to send the request to.
    # @param  [Hash] options A hash with additional options to pass to Faraday.
    # @see    OAuth2::Client#request
    # @return [Mixed]
    #
    def request(verb, url, options = {})
      @user_agent ||= "Forrst/#{Forrst::Version} (#{RUBY_DESCRIPTION})"

      # Be a nice guy and set those headers correctly
      Forrst.oauth.connection.headers = {
        'User-Agent' => @user_agent, 
        'Accept'     => 'application/json, text/javascript'
      }

      return Forrst.oauth.request(verb, url, options)
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
      response = Forrst.request(:get, StatisticsURL)
      response = JSON.load(response)
      hash     = {
        :limit => response['resp']['rate_limit'].to_i,
        :calls => response['resp']['calls_made'].to_i
      }
    
      return hash
    end
  end # class << self
end # Forrst
