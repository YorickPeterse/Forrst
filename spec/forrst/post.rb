require File.expand_path('../../helper', __FILE__)

describe('Forrst::Post') do

  it('Get a list of all code posts') do
    posts = Forrst::Post.find(:type => :code)

    posts.size.should                === 10
    posts[0].type.should             === 'code'
    posts[0].post_id.should          === 86456
    posts[0].created_at.class.should == Date
    posts[0].user.username.should    === 'bguillermo'
  end

  it('Get a list of all code posts sorted by popularity') do
    posts = Forrst::Post.find(:type => :code, :sort => :popular)

    posts.size.should                === 4
    posts[0].type.should             === 'code'
    posts[0].post_id.should          === 86034
    posts[0].user.username.should    === 'amatyr4n'
    posts[0].updated_at.class.should == Date
  end

  it('Retrieve a single post by it\'s ID') do
    post = Forrst::Post[86427]

    post.user.username.should === 'YorickPeterse'
    post.title.should         === 'Forrst API in Ruby'
    post.type.should          === 'link'
  end

  it('Retrieve a single post by it\'s tiny ID') do
    post = Forrst::Post['YPj']

    post.user.username.should === 'YorickPeterse'
    post.title.should         === 'Forrst API in Ruby'
    post.type.should          === 'link'
    post.link?.should         === true
  end

  it('Retrieve all posts') do
    posts = Forrst::Post.all

    posts.size.should             === 7
    posts[0].post_id.should       === 86541
    posts[0].user.username.should === 'jtkendall'
  end

  it('Retrieve all posts after a certain ID') do
    posts = Forrst::Post.all(:after => 86541)

    posts.size.should             === 7
    posts[0].post_id.should       === 86540
    posts[0].user.username.should === 'ericandrewscott'
  end

end
