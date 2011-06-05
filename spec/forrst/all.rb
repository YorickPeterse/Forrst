require File.expand_path('../../helper', __FILE__)
require 'rspec/autorun'

['monkeys/hash', 'user'].each do |spec|
  require File.expand_path("../#{spec}", __FILE__)
end
