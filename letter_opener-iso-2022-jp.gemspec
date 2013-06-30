# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "letter_opener-iso-2022-jp"
  spec.version       = "0.0.1.pre"
  spec.authors       = ["hamajyotan"]
  spec.email         = ["takashi.sakaguchi@ummm.info"]
  spec.description   = "gem letter_opener will not be able to correctly display ISO-2022-JP encoded email. This gem will eliminate the problem."
  spec.summary       = "letter_opener with iso-2022-jp encoding."
  spec.homepage      = "http://github.com/ummm/letter_opener-iso-2022-jp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "letter_opener"
end

