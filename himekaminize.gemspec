# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "himekaminize/version"

Gem::Specification.new do |spec|
  spec.name          = "himekaminize"
  spec.version       = Himekaminize::VERSION
  spec.authors       = ["otukutun"]
  spec.email         = ["orehaorz@gmail.com"]

  spec.summary       = "Utilities to extract markdown."
  spec.homepage      = "https://github.com/otukutun/himekaminize"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry', '~> 0'
end
