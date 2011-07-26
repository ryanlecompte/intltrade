# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "intltrade/version"

Gem::Specification.new do |s|
  s.name        = "intltrade"
  s.version     = InternationalTrade::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan LeCompte"]
  s.email       = ["lecompte@gmail.com"]
  s.homepage    = "http://github.com/ryanlecompte/intltrade"
  s.summary     = %q{international trade puzzle node solution}
  s.description = %q{international trade puzzle node solution - see http://www.puzzlenode.com for more info}

  s.rubyforge_project = "intltrade"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("nokogiri", ">= 1.4.4")
  s.add_development_dependency("rspec", "~> 2.5.0")
end
