# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-outputbuffer}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2010-03-01}
  s.description = %q{A Sinatra Extension that makes content output buffering easy.}
  s.email = %q{kematzy@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "CHANGES",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/sinatra/outputbuffer.rb",
     "spec/sinatra/outputbuffer_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kematzy/sinatra-outputbuffer}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A Sinatra Extension that makes content output buffering easy.}
  s.test_files = [
    "spec/sinatra/outputbuffer_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0.a"])
      s.add_development_dependency(%q<sinatra-tests>, [">= 0.1.6"])
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
    else
      s.add_dependency(%q<sinatra>, [">= 1.0.a"])
      s.add_dependency(%q<sinatra-tests>, [">= 0.1.6"])
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 1.0.a"])
    s.add_dependency(%q<sinatra-tests>, [">= 0.1.6"])
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
  end
end

