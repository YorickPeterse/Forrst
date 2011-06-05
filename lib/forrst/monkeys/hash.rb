class Hash < Object
  ##
  # Given a set of keys this method will create a new hash with those keys and their
  # values.
  #
  # @example
  #  {:name => "Chuck Norris", :age => 71}.subset(:age) # => {:age => 71}
  # 
  # @author Yorick Peterse
  # @since  0.1a
  # @param  [Array] keys The keys to retrieve from the hash.
  # @return [Hash]
  #
  def subset(*keys)
    new_hash = {}

    keys.each do |k|
      if self.key?(k)
        new_hash[k] = self[k]
      end
    end
    
    return new_hash
  end
end # Hash
