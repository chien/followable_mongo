require File.join(File.dirname(__FILE__), 'post')

class Comment
  include Mongoid::Document
  include Mongo::Followable

  field :content

  belongs_to :post

end
