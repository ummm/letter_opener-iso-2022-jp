# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "letter_opener-iso-2022-jp"
  spec.version       = "0.1.1"
  spec.authors       = ["hamajyotan"]
  spec.email         = ["takashi.sakaguchi@ummm.info"]
  spec.description   = "This patch provides 'letter_opener' gem with iso-2022-jp conversion capability."
  spec.summary       = "letter_opener with iso-2022-jp encoding."
  spec.homepage      = "http://github.com/ummm/letter_opener-iso-2022-jp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "mail-iso-2022-jp"
  spec.add_development_dependency "pry-byebug"

  spec.add_dependency "letter_opener"
end

