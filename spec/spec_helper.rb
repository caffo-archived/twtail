begin
  require 'rspec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'twtail'

$testing = true

Dir.glob(File.expand_path('../support/*.rb', __FILE__)) do |filename|
  require filename
end
