require File.expand_path('../../helper', __FILE__)

describe('Forrst::User') do

  it('Find a user by his ID') do
    user = Forrst::User[6998]

    user.username.should           === 'YorickPeterse'
    user.name.should               === 'Yorick Peterse'
    user.user_id.should            === 6998
    user.homepage.should           === 'http://yorickpeterse.com/'
    user.url.should                === 'http://forrst.com/people/YorickPeterse'
    user.twitter.should            === 'YorickPeterse'
    user.statistics[:posts].should === 32

    user.tags.empty?.should             === false
    user.type.should                    === ['developer']
    user.tags.include?('ramaze').should === true
  end

  it('Find a user by his username') do
    user = Forrst::User['YorickPeterse']

    user.username.should === 'YorickPeterse'
    user.name.should     === 'Yorick Peterse'
    user.user_id.should  === 6998
    user.homepage.should === 'http://yorickpeterse.com/'
    user.url.should      === 'http://forrst.com/people/YorickPeterse'
    user.twitter.should  === 'YorickPeterse'

    user.tags.empty?.should             === false
    user.type.should                    === ['developer']
    user.tags.include?('ramaze').should === true
  end

  it('Check if a user is a developer') do
    user = Forrst::User['YorickPeterse']

    user.developer?.should === true
  end

  it('Check if a user is a designer') do
    user = Forrst::User['YorickPeterse']

    user.designer?.should === false
  end

  it('Check if a user is both a designer and developer') do
    user = Forrst::User['YorickPeterse']

    user.developer_and_designer?.should === false
  end

  it('Get all the posts of a user') do
    user  = Forrst::User['YorickPeterse']
    posts = user.posts

    posts.size.should                === 10
    posts[0].post_id.should          === 86427
    posts[0].type.should             === 'link'
    posts[0].created_at.class.should == Date
    posts[0].user.username.should    === 'YorickPeterse'
  end

end
