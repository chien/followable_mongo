require 'followable_mongo/followable'
require 'followable_mongo/follower'
require 'followable_mongo/tasks'

if defined?(Rails)
  require 'followable_mongo/railtie'
end
