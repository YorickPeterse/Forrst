require File.expand_path('../../lib/forrst', __FILE__)
require 'rspec'

Faraday.default_adapter = :test

def get_fixture(name)
  path = File.expand_path("../fixtures/#{name}.json", __FILE__)
  return File.read(path, File.size(path))
end

RSpec.configure do |c|
  c.fail_fast = true
end

# Configure the library so we don't have to do this over and over again
Forrst.configure do |config|

end

# Set up the stub requests so we don't bombard the Forrst server
Forrst.oauth.connection = Faraday.new(Forrst.oauth.site)
Forrst.oauth.connection.build do |builder|
  builder.adapter(:test) do |stub|
    stub.get(Forrst::StatisticsURL) do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('stats')]
    end

    stub.get(Forrst::User::InfoURL + '?id=6998') do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('user/info')]
    end

    stub.get(Forrst::User::InfoURL + '?username=YorickPeterse') do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('user/info')]
    end

    stub.get(Forrst::User::PostsURL + '?username=YorickPeterse') do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('user/posts')]
    end

    stub.get(Forrst::Post::ListURL + '?post_type=code') do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('posts/list_code')]
    end

    stub.get(Forrst::Post::ListURL + '?post_type=code&sort=popular') do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('posts/list_popular')]
    end

    stub.get(Forrst::Post::ShowURL + '?id=86427') do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('posts/show')]
    end

    stub.get(Forrst::Post::ShowURL + '?tiny_id=YPj') do |env|
      [200, {'Content-Type' => 'application/json'}, get_fixture('posts/show')]
    end
  end
end
