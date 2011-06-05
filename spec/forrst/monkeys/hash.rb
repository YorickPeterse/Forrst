require File.expand_path('../../../helper', __FILE__)

describe('Hash') do

  it('Retrieve a subset of key/value pairs') do
    hash   = {:name => 'Chuck Norris', :age => 71, :location => 'USA'}
    subset = hash.subset(:name, :age)

    subset.should === {:name => 'Chuck Norris', :age => 71}
  end

end
