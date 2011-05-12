class Category
  include Mongoid::Document
  include Mongo::Followable

  field :name

  has_and_belongs_to_many :posts

end
