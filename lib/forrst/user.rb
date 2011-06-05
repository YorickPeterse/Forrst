module Forrst
  ##
  # Forrst::User is the class used for retrieving details about a particular user. A user
  # is retrieved by calling Forrst::User.find and passing a username or ID to it:
  #
  #     user = Forrst::User.find('yorickpeterse') => #<Forrst::User:0x1234567>
  #
  # Once an instance has been created you can retrieve various details, such as the
  # username, simply by calling methods on the resulting object:
  #
  #     user.username => 'YorickPeterse'
  #
  # @author Yorick Peterse
  # @since  0.1a
  # @attr_reader [String] username The username as used on Forrst.
  # @attr_reader [String] name The real name of the user.
  # @attr_reader [String] url The URL to the Forrst profile of the user.
  # @attr_reader [Fixnum] comment_count The amount of comments posted by the user.
  # @attr_reader [Fixnum] like_count The amount of likes.
  # @attr_reader [Fixnum] follower_count The amount of people the user is following.
  # @attr_reader [Fixnum] following_count The amount of people following the user.
  # @attr_reader [Fixnum] post_count The amount of posts published by the user.
  # @attr_reader [String] bio The biography of the user.
  # @attr_reader [String] twitter The Twitter username of the user.
  # @attr_reader [Hash] photos A hash containing the photos of the user. This hash has the
  # keys :extra_large, :large, :small and :thumbnail.
  # @attr_reader [Array] type The type of user, can be ['developer'], ['designer'] or
  # ['developer', 'designer'].
  # @attr_reader [String] homepage URL to the user's personal website.
  # @attr_reader [TrueClass/FalseClass] listed Whether or not the user is listed in the
  # Forrst.me directory.
  # @attr_reader [Array] tags An array of tags the user set in his profile.
  # @attr_reader [Fixnum] user_id The ID of the user.
  #
  class User
    ##
    # URL relative to Forrst::URL for retrieving user information.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    InfoURL = '/users/info'

    ##
    # URL relative to Forrst::URL for retrieving the posts of a user.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    PostsURL = '/users/posts'

    attr_reader :username, :name, :url, :statistics, :bio, :twitter, :photos, :type, 
      :homepage, :listed, :tags, :user_id

    ##
    # Retrieves a single user by it's username or ID and returns a new instance of
    # Forrst::User with these details.
    #
    # @example
    #  Forrst::User.find('yorickpeterse')
    #  Forrst::User.find(6998)
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [String/Fixnum] selector
    # @return [Forrst::User]
    #
    def self.find(selector)
      if selector.class == String
        selector = {:username => selector}
      elsif selector.class == Fixnum
        selector = {:id => selector}
      else
        raise(TypeError, "Expected Hash or Fixnum but got #{selector.class} instead")
      end

      response = Forrst.oauth.request(:get, InfoURL, selector)

      return User.new(response)
    end

    ##
    # Given a JSON response (as a string) this method will parse it using the JSON gem and
    # return a new instance of Forrst::User with all the details set.
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [String/Hash] response A string containing a JSON response sent back by the
    # Forrst server or an instance of Hash in case the response has already been parsed.
    # @return [Forrst::User]
    #
    def initialize(response)
      if response.class != Hash
        response = JSON.load(response)
        response = response['resp']
      end

      # We're not directly setting Forrst::User#id as that will trigger warnings in both
      # JRuby and Rubinius.
      @user_id   = response['id']
      @username  = response['username']
      @name      = response['name']
      @url       = response['url']
      @homepage  = response['homepage_url']
      @listed    = response['in_directory']
      @twitter   = response['twitter']
      @bio       = response['bio']

      @statistics = {
        :comments  => response['comments'].to_i,
        :likes     => response['likes'].to_i,
        :followers => response['followers'].to_i,
        :following => response['following'].to_i,
        :posts     => response['posts'].to_i
      }

      # Photos come as a hash with rather wacky keys so those need to be changed as well.
      @photos = {
        :extra_large => response['photos']['xl_url'],
        :large       => response['photos']['large_url'],
        :medium      => response['photos']['medium_url'],
        :small       => response['photos']['small_url'],
        :thumbnail   => response['photos']['thumb_url']
      }

      # Tags aren't always present
      if response.key?('tag_string')
        @tags = response['tag_string'].split(',')
      else
        @tags = []
      end

      # Last but not least, the user type!
      @type = response['is_a'].split('&').map { |i| i.strip }
    end

    ##
    # Retrieves all the posts for the current user. Each post is an instance of
    # Forrst::Post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [Hash] options A hash with additional options to use when retrieving all the
    # posts.
    # @option options [String/Symbol] :type The type of posts to retrieve such as :code or
    # :question.
    # @option options [Fixnum] :limit The amount of posts to retrieve.
    # @option options [After]  :after An ID offset used for retrieving a set of posts
    # after the given ID.
    # @return [Array]
    #
    def posts(options = {})
      options  = {
        :username => @username
      }.merge(options.subset(:limit, :type, :after))

      response = Forrst.oauth.request(:get, PostsURL, options)
      response = JSON.load(response)

      return response['resp'].map do |post|
        Forrst::Post.new(post)
      end
    end

    ##
    # Checks if the user is a developer or not.
    #
    # @author Yorick Peterse
    # @since  0.1
    # @return [TrueClass/FalseClass]
    #
    def developer?
      return @type === ['developer']
    end

    ##
    # Checks if the user is a designer or not.
    #
    # @author Yorick Peterse
    # @since  0.1
    # @return [TrueClass/FalseClass]
    #
    def designer?
      return @type === ['designer']
    end

    ##
    # Checks if the user is a developer and a designer.
    #
    # @author Yorick Peterse
    # @since  0.1
    # @return [TrueClass/FalseClass]
    #
    def developer_and_designer?
      # The shorthand "return A and B" generates a void error so we'll have to do it this
      # way.
      if @type.include?('designer') and @type.include?('developer')
        return true
      else
        return false
      end
    end
  end # User
end # Forrst
