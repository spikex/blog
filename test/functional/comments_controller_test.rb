require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  should_route :post, '/posts/5/comments', :action => 'create', :post_id => '5'

  context "on POST create with a post id and valid comment parameters" do
    setup do
      @post = Post.create(:title => 'title', :body => 'body')
      post :create, :post_id => @post.to_param,
                    :comment => { :title => 'title', :body => 'body' }
    end

    should_redirect_to "post_path(@post)"
    should_set_the_flash_to /added/
    
    should "create a comment for the given post" do
      assert_not_nil @post.comments.last
    end
  end

  context "on POST to create with a post id and invalid comment parameters" do
    setup do
      @post = Post.create(:title => 'title', :body => 'body')
      post :create, :post_id => @post.to_param,
                    :comment => {}
    end

    should_render_template :new
    should_respond_with :success
    should_not_set_the_flash

    should "have a form to post a comment" do
      assert_select 'form[action=?][method=post]', post_comments_path(@post) do
        assert_select 'input[type=text][name=?]', 'comment[title]'
        assert_select 'textarea[name=?]', 'comment[body]'
        assert_select 'input[type=submit]'
      end
    end

    should "display errors" do
      assert_select '#errorExplanation'
    end
  end
end
