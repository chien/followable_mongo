require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mongo::Follower do
  before :all do
    @post1 = Post.create!(:title => 'post1')
    @post2 = Post.create!(:title => 'post2' )

    @user1 = User.create!
    @user2 = User.create!
  end

  context "just created" do
    it 'validates' do
      Post.followed_by(@user1).should be_empty
      @user1.following?(@post1).should be_false
      @user1.following?(@post2).should be_false

      Post.followed_by(@user2).should be_empty
      @user2.following?(@post1).should be_false
      @user2.following?(@post2).should be_false
    end

  end

  context 'user1 follow up post1 the first time' do
    before :all do
      #@user1.follow(:followed_id => @post1.id, :followed_class => Post)
      @user1.follow(@post1)
      @post1.reload
    end

    it 'validates' do
      @post1.follows_count.should == 1

      @user1.should be_following(@post1)
      @user2.should_not be_following(:followed_class => Post, :followed_id => @post1.id)

      Post.followed_by(@user1).to_a.should == [ @post1 ]
      Post.followed_by(@user2).to_a.should be_empty

      User.following(@post1).to_a.should == [ @user1 ]
    end

    it 'user1 follow post1 has no effect' do
      @user1.follow(:followed => @post1)
      @post1.reload

      @post1.follows_count.should == 1
    end
  end

  context 'user2 follow down post1 the first time' do
    before :all do
      @user2.follow(:followed => @post1)
      @post1.reload
    end

    it 'validates' do
      @post1.follows_count.should == 2

      Post.followed_by(@user1).to_a.should == [ @post1 ]
      Post.followed_by(@user2).to_a.should == [ @post1 ]
      User.following(@post1).to_a.should == [ @user1, @user2 ]
    end
  end

  context 'user1 change follow on post1 from up to down' do
    before :all do
      @user1.follow(:followed => @post1)
      @post1.reload
    end

    it 'validates' do
      @post1.follows_count.should == 2
      Post.followed_by(@user1).to_a.should == [ @post1 ]
      Post.followed_by(@user2).to_a.should == [ @post1 ]
    end
  end

  context 'user1 follow down post2 the first time' do
    before :all do
      @user1.follow(:new => 'abc', :followed => @post2)
      @post2.reload
    end

    it 'validates' do
      @post2.follows_count.should == 1
      Post.followed_by(@user1).to_a.should == [ @post1, @post2 ]
    end
  end

end