begin
  require 'rspec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'rspec'
end

begin
  require 'mocha/standalone'
rescue LoadError
  require 'rubygems'
  gem 'mocha'
  require 'mocha/standalone'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'twtail'

$testing = true

Dir.glob(File.expand_path('../support/*.rb', __FILE__)) do |filename|
  require filename
end

RSpec.configure do |config|

  config.mock_with :mocha

  config.include Fixtures

end
