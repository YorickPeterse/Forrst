require File.expand_path('../../helper', __FILE__)

describe('Forrst::Post') do
  
  it('Get a list of all code posts') do
    posts = Forrst::Post.find(:type => :code)

    posts.size.should                === 10
    posts[0].type.should             === 'code'
    posts[0].post_id.should          === 86456
    posts[0].created_at.class.should == Time
    posts[0].user.username.should    === 'bguillermo'
  end

  it('Get a list of all code posts sorted by popularity') do
    posts = Forrst::Post.find(:type => :code, :sort => :popular)

    posts.size.should                === 4
    posts[0].type.should             === 'code'
    posts[0].post_id.should          === 86034
    posts[0].user.username.should    === 'amatyr4n'
    posts[0].updated_at.class.should == Time
  end

end
