# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = "twtail"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["rodrigo franco (caffo)"]
  s.date = "2012-08-30"
  s.description = "twitter tail based on search.twitter.com - works perfectly with crappy internet connections usually available at tech conferences"
  s.email = "caffeine@gmail.com"
  s.executables = ["twtail"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
    "VERSION",
    "bin/twtail",
    "lib/twtail.rb",
    "spec/spec_helper.rb",
    "spec/twtail_spec.rb",
    "twtail.gemspec"
  ]
  s.homepage = "http://github.com/caffo/twtail"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "twitter tail based on search.twitter.com - works perfectly with crappy internet connections usually available at tech conferences"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<htmlentities>, [">= 4.2.1"])
      s.add_runtime_dependency(%q<simple-rss>, [">= 1.2.2"])
    else
      s.add_dependency(%q<htmlentities>, [">= 4.2.1"])
      s.add_dependency(%q<simple-rss>, [">= 1.2.2"])
    end
  else
    s.add_dependency(%q<htmlentities>, [">= 4.2.1"])
    s.add_dependency(%q<simple-rss>, [">= 1.2.2"])
  end
  
  s.add_development_dependency "rake"
  s.add_development_dependency 'rspec', '>= 2.11.0'
end