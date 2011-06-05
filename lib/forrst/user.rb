module Forrst
  ##
  # Forrst::User is the class used for retrieving details about a particular user. A user
  # is retrieved by calling Forrst::User.[] and passing a username or ID to it:
  #
  #     user = Forrst::User['yorickpeterse'] => #<Forrst::User:0x1234567>
  #
  # Once an instance has been created you can retrieve various details, such as the
  # username, simply by calling methods on the resulting object:
  #
  #     user.username => 'YorickPeterse'
  #
  # It's important to remember that the number of comments, posts and such are accessed
  # using methods such as "comment_count" and "post_count". This is because (hopefully) in
  # the future the API will allow developers to retrieve a list of all posts that were
  # liked by a user, all users he's following and so on. Currently only posts can be
  # retrieved from a user by calling Forrst::User#posts.
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
    # URL relative to Forrst::URL for retrieving user related data.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    URL = '/users/info'

    attr_reader :username, :name, :url, :comment_count, :like_count, :follower_count, 
      :following_count, :post_count, :bio, :twitter , :photos, :type, :homepage, :listed, 
      :tags, :user_id

    ##
    # Retrieves a single user by it's username or ID and returns a new instance of
    # Forrst::User with these details.
    #
    # @example
    #  Forrst::User['yorickpeterse']
    #  Forrst::User[6998]
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [String/Fixnum] selector
    # @return [Forrst::User]
    #
    def self.[](selector)
      if selector.class == String
        selector = {:username => selector}
      elsif selector.class == Fixnum
        selector = {:id => selector}
      else
        raise(TypeError, "Expected Hash or Fixnum but got #{selector.class} instead")
      end

      response = Forrst.oauth.request(:get, URL, selector)

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
      end

      # We're not directly setting Forrst::User#id as that will trigger warnings in both
      # JRuby and Rubinius.
      @user_id   = response['resp']['id']
      @username  = response['resp']['username']
      @name      = response['resp']['name']
      @url       = response['resp']['url']
      @homepage  = response['resp']['homepage_url']
      @listed    = response['resp']['in_directory']
      @twitter   = response['resp']['twitter']
      @bio       = response['resp']['bio']

      @comment_count   = response['resp']['comments'].to_i
      @like_count      = response['resp']['likes'].to_i
      @follower_count  = response['resp']['followers'].to_i
      @following_count = response['resp']['following'].to_i
      @post_count      = response['resp']['posts'].to_i

      # Photos come as a hash with rather wacky keys so those need to be changed as well.
      @photos = {
        :extra_large => response['resp']['photos']['xl_url'],
        :large       => response['resp']['photos']['large_url'],
        :medium      => response['resp']['photos']['medium_url'],
        :small       => response['resp']['photos']['small_url'],
        :thumbnail   => response['resp']['photos']['thumb_url']
      }

      # Tags aren't always present
      if response['resp'].key?('tag_string')
        @tags = response['resp']['tag_string'].split(',')
      else
        @tags = []
      end

      # Last but not least, the user type!
      @type = response['resp']['is_a'].split('&').map { |i| i.strip }
    end

    ##
    # Retrieves all the posts for the current user. Each post is an instance of
    # Forrst::Post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @return [Array]
    #
    def posts
      
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
