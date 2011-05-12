require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mongo::Followable::Tasks do
  describe 'Mongo::Followable::Tasks.init_stats' do
    before :all do
      @post1 = Post.create!
      @post2 = Post.create!
    end

    it 'after create follows has default value' do
      @post1.follows.should == ::Mongo::Followable::DEFAULT_FOLLOWS
      @post2.follows.should == ::Mongo::Followable::DEFAULT_FOLLOWS
    end

    it 'reset follows data' do
      @post1.follows = nil
      @post1.save

      @post2.follows = nil
      @post2.save
    end

  end
end
