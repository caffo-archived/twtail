begin
  require 'rspec'
rescue LoadError
  require 'rubygems'
  require 'rspec'
end
begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec2 gem:
    gem install rspec
EOS
  exit(0)
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "twtail"
    gem.summary = "twitter tail based on search.twitter.com - works perfectly with crappy internet connections usually available at tech conferences"
    gem.description = "twitter tail based on search.twitter.com - works perfectly with crappy internet connections usually available at tech conferences"
    gem.email = "caffeine@gmail.com"
    gem.homepage = "http://github.com/caffo/twtail"
    gem.authors = ["rodrigo franco (caffo)"]
    gem.add_dependency "htmlentities", ">= 4.2.1"
    gem.add_dependency "simple-rss", ">= 1.2.2"
    gem.add_development_dependency 'rspec', '>= 2.11.0'
    gem.add_development_dependency 'mocha', '~> 0.12.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "twtail #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
end

task :default do
  puts "\nAvailable tasks: #{Rake.application.tasks.to_a.join(', ')}"
  puts "Use rake -T for more info.\n\n"
end
