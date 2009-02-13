require 'test_helper'

class PostsHelperTest < ActionView::TestCase
  should "display an author's name for a post with an author" do
    post = Post.create(:title => 'title', :body => 'body', :author => 'Joe')
    assert_equal 'Joe', display_author_of(post)
  end

  should "display 'Anonymous' for a post without an author" do
    post = Post.create(:title => 'title', :body => 'body', :author => '')
    assert_equal 'Anonymous', display_author_of(post)
  end
end
