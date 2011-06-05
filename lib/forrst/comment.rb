module Forrst
  ##
  # Forrst::Comment is a class used for individual comments.
  #
  # @author Yorick Peterse
  # @since  0.1a
  #
  class Comment
    ##
    # The ID of the comment.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :comment_id

    ##
    # An instance of Forrst::User containing the details of the user.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :user

    ##
    # The body of the comment.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :body

    ##
    # The date and time on which the comment was created.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :created_at

    ##
    # The date and time on which the comment was updated.
    #
    # @author Yorick Peterse
    # @since  0.1a
    #
    attr_reader :updated_at

    ##
    # Creates a new instance of Forrst::Comment and parses the response (either in JSON or
    # as a has).
    #
    # @author Yorick Peterse
    # @since  0.1a
    # @param  [String/Hash] response The API response sent back from the server.
    #
    def initialize(response)
      if response.class != Hash
        response = JSON.load(response)
      end

      @comment_id = response['id']
      @user       = Forrst::User.new(response['user'])
      @body       = response['body']
      @created_at = Date.strptime(response['created_at'], Forrst::DateFormat)
      @updated_at = Date.strptime(response['updated_at'], Forrst::DateFormat)
    end
  end # Comment
end # Forrst
