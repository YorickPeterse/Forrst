require File.expand_path('../lib/forrst/version', __FILE__)

# Get all the files from the manifest
manifest = File.open './MANIFEST', 'r'
manifest = manifest.read.strip
manifest = manifest.split "\n"

Gem::Specification.new do |s|
  s.name        = 'forrst'
  s.version     = Forrst::Version
  s.date        = '04-06-2011'
  s.authors     = ['Yorick Peterse']
  s.email       = 'info@yorickpeterse.com'
  s.summary     = 'Ruby API for Forrst'
  s.homepage    = 'https://github.com/yorickpeterse/forrst'
  s.description = 'A Ruby library for the Forrst API.'
  s.files       = manifest
  s.has_rdoc    = 'yard'

  s.add_dependency('json'  , ['~> 1.5.1'])
  s.add_dependency('oauth2', ['~> 0.4.1'])
  
  s.add_development_dependency('rake' , ['= 0.8.7'])
	s.add_development_dependency('rspec', ['>= 2.6.0'])
	s.add_development_dependency('yard' , ['>= 0.7.1'])
end
