class User
  include MongoMapper::Document
  include Mongo::Follower
end
