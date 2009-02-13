require 'test_helper'

class PostTest < ActiveSupport::TestCase

  should_have_many :comments
  should_validate_presence_of :title, :body

  context "given published and unpublished post" do
    setup do
      @post1 = Factory(:published_post,:created_at => 10.minutes.ago)
      @post2 = Factory(:published_post,:created_at => 5.minutes.ago)
      @post3 = Factory(:post,:created_at => 5.minutes.ago)
    end
    
    should "only return published posts" do
      Post.published.each do |post|
        assert post.published?
      end
    end
 
  end
  
  context "given post created at different times" do
    setup do
      @post1 = Factory(:published_post,:created_at => 10.minutes.ago)
      @post2 = Factory(:published_post,:created_at => 5.minutes.ago)
      @post3 = Factory(:post,:created_at => 1.minutes.ago)
    end
    
    should "return posts order by creation time" do
      assert_equal [@post3, @post2, @post1], Post.newer
    end
 
  end
  
  context "given published and unpublished post, created at different times" do
    setup do
      @post1 = Factory(:published_post,:created_at => 10.minutes.ago)
      @post2 = Factory(:published_post,:created_at => 5.minutes.ago)
      @post3 = Factory(:post,:created_at => 1.minutes.ago)
    end
    should "return published posts ordered by creation time" do
      assert_equal [@post2, @post1], Post.latest
    end
  end
end
