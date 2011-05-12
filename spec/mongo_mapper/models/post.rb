require File.join(File.dirname(__FILE__), 'category')

class Post
  include MongoMapper::Document
  include Mongo::Followable

  key :title, String
  key :content, String

  key :category_ids, Array
  many :categories, :in => :category_ids

  many :comments
end
