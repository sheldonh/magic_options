# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "magic_options/version"

Gem::Specification.new do |s|
  s.name        = "magic_options"
  s.version     = MagicOptions::VERSION
  s.authors     = ["Sheldon Hearn", "Rory McKinley"]
  s.email       = ["sheldonh@starjuice.net", "rorymckinley@gmail.com"]
  s.homepage    = "http://github.com/sheldonh/magic_options"
  s.summary     = "Ruby module to provide initialize with magic options"

  s.rubyforge_project = "magic_options"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rspec')
end
