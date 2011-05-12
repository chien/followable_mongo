require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mongo::Followable do
  before :all do
    Post.delete_all
    Category.delete_all
    User.delete_all
    Comment.delete_all

    @category1 = Category.create!(:name => 'xyz')
    @category2 = Category.create!(:name => 'abc')

    @post1 = Post.create!(:title => 'post1', :category_ids => [@category1.id, @category2.id])
    @post2 = Post.create!(:title => 'post2' )

    @comment = @post2.comments.create!

    @user1 = User.create!
    @user2 = User.create!
  end

  it "follow for unexisting post" do
    @user1.follow(:followed_class => Post, :followed_id => BSON::ObjectId.new).should == false
  end

  context "just created" do
    it 'follows_count should be zero' do
      @category1.follows_count.should == 0
      @category2.follows_count.should == 0
      @post1.follows_count.should == 0
      @post2.follows_count.should == 0
      @comment.follows_count.should == 0
    end

    it 'follower_ids should be empty' do
      @category1.follower_ids.should be_empty
      @category2.follower_ids.should be_empty
      @post1.follower_ids.should be_empty
      @post2.follower_ids.should be_empty
      @comment.follower_ids.should be_empty
    end

    it 'followed by follower should be empty' do
      Category.followed_by(@user1).should be_empty
      Category.followed_by(@user2).should be_empty

      Post.followed_by(@user1).should be_empty
      Post.followed_by(@user2).should be_empty

      Comment.followed_by(@user1).should be_empty
      Comment.followed_by(@user2).should be_empty
    end

  end
  context 'user1 follow post1 the first time' do
    before :all do
      @post = @post1.follow(:follower_id => @user1.id)
    end

    it 'validates return post' do
      @post.should be_is_a Post
      @post.should_not be_new_record

      @post.follows.should == {
        'followers' => [@user1.id],
        'count' => 1
      }
    end

    it 'validates' do
      @post1.follows_count.should == 1

      @post1.should be_followed_by(@user1)
      @post1.should_not be_followed_by(@user2.id)

      @post1.followers(User).to_a.should == [ @user1 ]

      Post.followed_by(@user1).to_a.should == [ @post1 ]
      Post.followed_by(@user2).to_a.should be_empty

      @category1.reload
      @category1.follows_count.should == 0

      @category2.reload
      @category2.follows_count.should == 0
    end

    it 'user1 follow post1 has no effect' do
      Post.follow(:followed_id => @post1.id, :follower_id => @user1.id)
      @post1.reload

      @post1.follows_count.should == 1
    end
  end

  context 'user2 follow post1 the first time' do
    before :all do
      Post.follow(:followed_id => @post1.id, :follower_id => @user2.id)
      @post1.reload
    end

    it 'post1 follows_count has changed' do
      @post1.follows_count.should == 2
    end

    it 'post1 get followers' do
      @post1.followers(User).to_a.should == [ @user1, @user2 ]
    end

    it 'posts followed_by user1, user2 is post1 only' do
      Post.followed_by(@user1).to_a.should == [ @post1 ]
      Post.followed_by(@user2).to_a.should == [ @post1 ]
    end

    it 'categories follows' do
      @category1.reload
      @category1.follows_count.should == 0

      @category2.reload
      @category2.follows_count.should == 0
    end
  end

  context 'user1 unfollow on post1' do
    before :all do
      Post.unfollow(:followed_id => @post1.id, :follower_id => @user1.id)
      @post1.reload
    end

    it 'validates' do
      @post1.follows_count.should == 1
      Post.followed_by(@user1).to_a.should == []
      Post.followed_by(@user2).to_a.should == [ @post1 ]
    end
  end

  context 'final' do
    it "test remake stats" do
      Mongo::Followable::Tasks.remake_stats

      @post1.follows_count.should == 1
      @post2.follows_count.should == 0
    end
  end

end
