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

    attr_reader :post_id, :tiny_id, :type, :post_url, :created_at, :updated_at, :user, 
      :published, :public, :title, :url, :content, :description, :formatted_description,
      :statistics, :tags, :snaps

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
  end
end
