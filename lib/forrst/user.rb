module Forrst
  ##
  # Forrst::User is the class used for retrieving details about a particular user. A user
  # is retrieved by calling Forrst::User[] and passing a username or ID to it:
  #
  #     user = Forrst::User['yorickpeterse'] => #<Forrst::User:0x1234567>
  #
  # Once an instance has been created you can retrieve various details, such as the
  # username, simply by calling methods on the resulting object:
  #
  #     user.username => 'YorickPeterse'
  #
  # When retrieving a user you can retrieve the user's posts by calling Forrst::User#posts
  # as following:
  #
  #     user.posts.each do |post|
  #       puts post.title
  #     end
  #
  # When retrieving the user's posts the library will use the class Forrst::Post which
  # allows you to retrieve post related data such as all the comments:
  #
  #     user.posts.each do |post|
  #       post.comments.each do |comment|
  #         puts comment.body
  #       end
  #     end
  #
  # Note that comments are lazy loaded. This means that for each iteration in the posts
  # array a GET request is fired to the Forrst API. Currently there's no way to work
  # around this so you'll have to be careful with using this method.
  #
  # This class also provides the following shortcut methods for figuring out the type of
  # user:
  #
  # * developer?
  # * designer?
  # * developer_and_designer?
  #
  # These can be used as following:
  #
  #     if user.developer?
  #       puts "It's a nerd!"
  #     elsif user.designer?
  #       puts "It's a hippie!"
  #     end
  #
  # @author Yorick Peterse
  # @since  0.1a
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

    ##
    # The user's ID.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :user_id

    ##
    # The username as used on Forrst.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :username

    ##
    # The real name of the user.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :name

    ##
    # The URL to the Forrst profile of the user.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :url

    ##
    # A hash containing various statistics such as the amount of comments, likes, etc.
    # Note that the keys of this hash are symbols, not strings.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :statistics

    ##
    # The description of the user.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :bio

    ##
    # The Twitter username of the user.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :twitter

    ##
    # A hash containing all the photos of the user. All the keys of this hash are symbols
    # just like the statistics hash.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :photos

    ##
    # An array containing the types of the user. Can be any of the following:
    #
    # * ['developer']
    # * ['designer']
    # * ['developer', 'designer']
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :type

    ##
    # The URL to the user's website.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :homepage

    ##
    # A boolean that indicates if the user is listed in the Forrst.me directory or not.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :listed

    ##
    # An array of tags for the user.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :tags

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
    # @param  [String/Fixnum] options
    # @return [Forrst::User]
    #
    def self.[](options)
      if options.class == String
        options = {:username => options}
      elsif options.class == Fixnum
        options = {:id => options.to_s}
      else
        raise(TypeError, "Expected Hash or Fixnum but got #{options.class} instead")
      end

      response = Forrst.request(:get, InfoURL, options)

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

      response = Forrst.request(:get, PostsURL, options)
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
