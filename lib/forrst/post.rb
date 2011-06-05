module Forrst
  ##
  # Forrst::Post is the class that represents a single post.
  #
  # @author Yorick Peterse
  # @since  0.1a
  #
  class Post
    ##
    # URL relative to Forrst::URL that contains the details of a single post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    ShowURL = '/posts/show'

    ##
    # URL relative to Forrst::URL that contains a list of all posts.
    #
    # @author Yorick Peterse
    # @since  0.1
    #
    ListURL = '/posts/list'

    ##
    # The ID of the post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :post_id

    ##
    # The "slug" that's added to the URL.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :tiny_id

    ##
    # The type of post ("code" for example).
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :type

    ##
    # The URL to the post on Forrst.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :post_url

    ##
    # The date and time on which the post was created.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :created_at

    ##
    # The date and time on which the post was updated.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :updated_at

    ##
    # The author of the post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :user

    ##
    # Boolean that indicates if the post has been published or not.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :published

    ##
    # Boolean that indicates if the post is a public post or requires users to log in.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :public

    ##
    # The title of the post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :title

    ##
    # If the post type was a link this field will contain the URL to the external page.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :url

    ##
    # The content of the post. If it's a question this field contains the question, if 
    # it's a code post it will contain the code attached to the post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :content

    ##
    # Field containing the description of the post, not used for questions.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :description

    ##
    # The description in HTML.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :formatted_description

    ##
    # The content in HTML.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :formatted_content

    ##
    # A hash containing the number of comments, likes, etc.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :statistics

    ##
    # An array of all the tags used in the post.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :tags

    ##
    # A hash containing the URLs to various sizes of the snap in case the post type is 
    # "snap".
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :snaps

    ##
    # Given a custom set of options this method will retrieve a list of posts. It's
    # important to remember that the keys of the hash passed to this method should be
    # symbols and *not* strings.
    #
    # Note that this method will always return an array of posts, if you want to retrieve
    # a single post use Forrst::Post[] instead.
    #
    # @example
    #  Forrst::Post.find(:type => :question)
    #  Forrst::Post.find(:type => :code, :sort => :recent)
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [Hash] options
    # @option options [Symbol] :type The type of posts to retrieve. Can be one of
    # the following: code, snap, link or question.
    # @option options [Symbol] :sort The sort order to use, can be any of the
    # following: recent, popular or best.
    # @option options [Fixnum] :page The page to use. Each page contains a (currently
    # unknown) number of posts.
    # @return [Array]
    #
    def self.find(options)
      # Set the correct keys for the API call
      query_items             = {}
      query_items[:post_type] = options[:type].to_s if options.key?(:type)
      query_items[:sort]      = options[:sort].to_s if options.key?(:sort)
      query_items[:page]      = options[:page].to_s if options.key?(:page)

      response = Forrst.oauth.request(:get, ListURL, query_items)
      response = JSON.load(response)
      
      return response['resp']['posts'].map do |post|
        Post.new(post)
      end
    end

    ##
    # Retrieves a single post by it's ID or tiny ID. If the parameter given is a Fixnum
    # this method assumes is the ID, if it's a string it assumes it's the tiny ID.
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [Fixnum/String] id The ID or the tiny ID.
    # @return [Forrst::Post]
    #
    def self.[](id)
      if id.class == Fixnum
        query_items = {:id => id}
      elsif id.class == String
        query_items = {:tiny_id => id}
      else
        raise(TypeError, "Got #{id.class} but expected Fixnum or String")
      end

      response = Forrst.oauth.request(:get, ShowURL, query_items)
      response = JSON.load(response)

      return Post.new(response['resp'])
    end

    ##
    # Creates a new instance of Forrst::Post and optionally decodes a JSON response. If a
    # response is already decoded it's data is merely assigned to the current instance.
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [String/Hash] response The API response in either JSON format or a hash.
    # @return [Forrst::Post]
    #
    def initialize(response)
      if response.class != Hash
        response = JSON.load(response)
      end

      @post_id     = response['id'].to_i
      @tiny_id     = response['id']
      @type        = response['post_type']
      @post_url    = response['post_url']
      @created_at  = Date.parse(response['created_at']).to_time
      @updated_at  = Date.parse(response['updated_at']).to_time
      @user        = Forrst::User.new(response['user'])
      @published   = response['published']
      @public      = response['public']
      @title       = response['title']
      @url         = response['url']
      @content     = response['content']

      @description           = response['description']
      @formatted_description = response['formatted_description']
      @formatted_content     = response['formatted_content']
      @tags                  = response['tags']

      @statistics = {
        :comments => response['comment_count'].to_i,
        :likes    => response['like_count'].to_i
      }

      # Get all the snaps
      @snaps = {}

      if response.key?('snaps')
        @snaps[:extra_large] = response['snaps']['mega_url']
        @snaps[:keith]       = response['snaps']['keith_url'] # The fuck is a keith?
        @snaps[:large]       = response['snaps']['large_url']
        @snaps[:medium]      = response['snaps']['medium_url']
        @snaps[:small]       = response['snaps']['small_url']
        @snaps[:thumbnail]   = response['snaps']['thumb_url']
        @snaps[:original]    = response['snaps']['original_url']
      end
    end
  end # Post
end # Forrst
