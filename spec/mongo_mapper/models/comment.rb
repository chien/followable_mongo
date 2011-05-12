require File.join(File.dirname(__FILE__), 'post')

class Comment
  include MongoMapper::Document
  include Mongo::Followable

  key :content, String

  belongs_to :post
end
