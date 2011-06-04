# Forrst

**IMPORTANT:** this library is still in the early stages of development. More details will
be added once it reaches a stable version.

forrst is a Ruby library for the [Forrst][forrst] API. This implementation aims to become
an implementation that focuses on ease of use, minimal amount of dependencies and
stability. I'm also aiming for support of all Ruby distributions such as JRuby and MRI.

## Quick Example

```ruby
Forrst.configure do |client|
  client.id           = 'oauth id'
  client.secret       = 'oauth secret'
  client.access_token = '1234abc'
end

# Get a user
user = Forrst::User[:username => 'Yorick Peterse']

# Or
user = Forrst::User[6998]

# Show some details of the user
user.post_count    # => 32
user.comment_count # => 281

# Loop through all the posts of a user (these aren't loaded until needed)
user.posts.each do |post|
  puts post.title
end
```

## License

This API is licensed under the MIT license. A copy of this license can be found in the
file "LICENSE".

[forrst]: http://forrst.com/
