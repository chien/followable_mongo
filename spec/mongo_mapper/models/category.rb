class Category
  include MongoMapper::Document
  include Mongo::Followable

  key :name, String

  key :post_ids, Array
  many :posts, :in => :post_ids
end
