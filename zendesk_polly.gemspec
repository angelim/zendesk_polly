# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zendesk_polly/version'

Gem::Specification.new do |spec|
  spec.name          = "zendesk_polly"
  spec.version       = ZendeskPolly::VERSION
  spec.authors       = ["Alexandre Angelim"]
  spec.email         = ["angelim@angelim.com.br"]

  spec.summary       = %q{Zendesk Talk integration with AWS Polly}
  spec.description   = %q{Create Zendesk Talk greetings using AWS Polly text-to-speech engine}
  spec.homepage      = "http://github.com/angelim/zendesk_polly"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'commander', '~> 4.4.3'
  spec.add_dependency 'aws-sdk', '~> 2.10.7'
  spec.add_dependency 'zendesk_api', '~> 1.14.4'
  spec.add_dependency 'launchy', '~> 2.4.3'
  spec.add_dependency 'command_line_reporter', '>=3.0'
  
  spec.add_development_dependency "pry-nav", "~> 0.2.4"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
