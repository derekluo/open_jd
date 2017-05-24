# -*- encoding: utf-8 -*-
require File.expand_path('../lib/open_jd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['jinanlongen.com']
  gem.email         = ['dev@jinanlongen.com']
  gem.description   = %q{京东开放平台 Ruby 版}
  gem.summary       = %q{Open JD API for ruby}
  gem.homepage      = 'https://github.com/derekluo/open_jd'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'open_jd'
  gem.license       = 'MIT'
  gem.require_paths = ['lib']
  gem.version       = OpenJd::VERSION

  gem.add_dependency 'multi_json', '>= 0'
  gem.add_dependency 'faraday', '>= 0'
  gem.add_development_dependency 'rspec', '>= 0'
  gem.add_development_dependency 'rake', '>= 0'
end
