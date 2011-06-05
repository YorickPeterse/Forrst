desc 'Runs all the tests'
task :test do
  spec_path = File.expand_path('../../spec/', __FILE__)
  sh("cd #{spec_path}; ruby forrst/all.rb")
end
