require 'test_helper'

class PostTest < ActiveSupport::TestCase

  should_have_many :comments

  context "a valid post" do
    setup do
      @post = Post.new(:title => 'title', :body => 'body')
      assert_valid @post
    end

    should "be invalid after removing the title" do
      @post.title = nil
      assert !@post.valid?
      assert !@post.errors.on(:title).blank?
    end

    should "be invalid after removing the body" do
      @post.body = nil
      assert !@post.valid?
      assert !@post.errors.on(:body).blank?
    end
  end

end
