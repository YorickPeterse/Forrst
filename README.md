# Forrst

**IMPORTANT:** this library is still in the early stages of development. More details will
be added once it reaches a stable version.

forrst is a Ruby library for the [Forrst][forrst] API. This implementation aims to become
an implementation that focuses on ease of use, minimal amount of dependencies and
stability. I'm also aiming for support of all Ruby distributions such as JRuby and MRI.

## Example

    require 'rubygems'
    require 'forrst'

    Forrst.configure do |config|
      config.id           = '123'
      config.secret       = '123'
      config.access_token = '123'
    end

    # Get a single user
    user = Forrst::User['YorickPeterse']
    user.name    # => 'Yorick Peterse'
    user.twitter # => 'YorickPeterse'

    # Get a bunch of posts
    posts = Forrst::Post.find(:type => :code, :sort => :popular)
    posts.each do |post|
      puts post.title
      puts post.user.username
    end

    # Or get a single post by it's ID or tiny ID
    post = Forrst::Post[123]
    post = Forrst::Post['YJp']

    post.title # => 'Some post title'

    post.comments.each do |comment|
      puts comment.body
    end

## Requirements & Installation

* Ruby 1.8.7, Rubinius, JRuby or Ruby 1.9.2 (1.9.1 and 1.9 are untested)
* An authenticated application (not available at the moment)
* RVM (when developing the library itself)

Installing the gem can be done in a single command:

    $ gem install forrst

If you want to submit pull requests or just check out the source code you should run the
following commands instead:

    $ git clone git://github.com/YorickPeterse/Forrst.git forrst
    $ cd forrst
    $ rvm gemset import .gems
    $ rake test

The command `rake test` is not required but recommended as it will check to see if your
environment is running the tests properly.

## License

This API is licensed under the MIT license. A copy of this license can be found in the
file "LICENSE".

[forrst]: http://forrst.com/
