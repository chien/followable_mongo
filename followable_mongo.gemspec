# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'followable_mongo/version'

Gem::Specification.new do |s|
  s.name        = 'followable_mongo'
  s.version     = FollowableMongo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['John Lynch', 'Alex Nguyen']
  s.email       = ['john@rigelgroupllc.com']
  s.homepage    = 'https://github.com/johnthethird/followable_mongo'
  s.summary     = %q{Add following ability to Mongoid and MongoMapper documents}
  s.description = %q{Add following ability to Mongoid and MongoMapper documents. Optimized for speed by using only ONE request to MongoDB to validate, update, and retrieve updated data.}

  s.add_development_dependency 'rspec', '~> 2.5.0'
  s.add_development_dependency 'mongoid', '~> 2.0.0'
  s.add_development_dependency 'mongo_mapper', '~> 0.9.0'
  s.add_development_dependency 'bson_ext', '~> 1.3.0'

  s.rubyforge_project = 'followable_mongo'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
