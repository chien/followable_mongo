require File.join(File.dirname(__FILE__), 'category')

class Post
  include Mongoid::Document
  include Mongo::Followable

  field :title
  field :content

  has_and_belongs_to_many :categories
  has_many :comments

end
