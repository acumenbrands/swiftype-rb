$:.push File.expand_path("../lib", __FILE__)
require "swiftype/version"

Gem::Specification.new do |s|
  s.name        = "swiftype"
  s.version     = Swiftype::VERSION
  s.authors     = ["Quin Hoxie", "Matt Riley"]
  s.email       = ["team@swiftype.com"]
  s.homepage    = "https://swiftype.com"
  s.summary     = %q{Official gem for accessing the Swiftype Search API}
  s.description = %q{API client for accessing the Swiftype Search API with no dependencies (on Ruby 1.9, JSON needed for Ruby 1.8).}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'redcarpet'
  if RUBY_VERSION < '1.9'
    s.add_runtime_dependency 'json'
  end
end
