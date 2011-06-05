require File.expand_path('../../helper', __FILE__)

['forrst', 'user'].each do |spec|
  require File.expand_path("../#{spec}", __FILE__)
end
