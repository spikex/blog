require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  should_route :get, '/posts', :action => :index

  include PostsHelper

  context 'on GET to index' do
    setup do
      @post1 = Factory(:published_post,:created_at => 10.minutes.ago)
      @post2 = Factory(:published_post,:created_at => 5.minutes.ago)
      @post3 = Factory(:post,:created_at => 5.minutes.ago)
      get :index
    end

    should_respond_with :success
    should_render_template :index

    should "render navigation with a link to new post" do
      assert_select 'div.navigation' do
        assert_select 'a[href=?]', posts_path, :count => 0
      end
    end

    should "show the current time in a paragraph" do
      assert_select 'p', :text => /The time is now/
    end

    should "sort the posts, most recent first, and assign to @posts" do
      reverse_sorted_posts = [@post2, @post1]
      assert_equal reverse_sorted_posts, assigns(:posts)
    end

    should "show only published posts" do
      assigns(:posts).each { |post| post.published? }
    end
    
    should "render the posts" do
      assigns(:posts).each do |post|
        assert_select 'h2>a[href=?]', post_path(post), :text => post.title
        assert_select 'p', display_author_of(post)
        assert_select 'p', post.body
      end
    end

    should "show a link to create a new post" do
      assert_select 'a[href=?]', new_post_path
    end
  end

  context "on GET to show for a published post" do
    setup do
      @post = Factory(:post,:title => 'Title', :body => 'Body', :published => true)
      @comment = Factory(:comment,:post => @post, :title => 'Comment Title',
                                        :body  => 'Comment Body')
      get :show, :id => @post
    end

    should_respond_with :success
    should_render_template :show
    should_assign_to :comment

    should "render the post" do
      assert_select 'h2>a[href=?]', post_path(@post), :text => 'Title'
      assert_select 'p', 'Body'
    end

    should "have a form to post a comment" do
      assert_select 'form[action=?][method=post]', post_comments_path(@post) do
        assert_select 'input[type=text][name=?]', 'comment[title]'
        assert_select 'textarea[name=?]', 'comment[body]'
        assert_select 'input[type=submit]'
      end
    end

    should "display comments" do
      assert_select 'h3', 'Comment Title'
      assert_select 'p', 'Comment Body'
    end
    
    should "display title" do
      assert_select 'title', @post.title
      assert_select 'h1', @post.title
    end
  
  end

  context "on GET to show for a published post with comments" do
    setup do
      @post = Factory(:post,:title => 'Title', :body => 'Body', :published => true)
      @comment = Factory(:comment,:post => @post, :title => 'Comment Title',
                                        :body  => 'Comment Body')
      get :show, :id => @post
    end

    should_respond_with :success
    should_render_template :show
    should_assign_to :comment
    
    should "have a form to post a comment" do
      assert_select 'form[action=?][method=post]', post_comment_path(@post,@comment) do
        assert_select 'input[type=hidden][name=_method][value=delete]'
        assert_select 'input[type=submit]'
      end
    end
  end

  context "on GET to show for an unpublished post" do
    setup do
      @post = Factory(:post, :published => false)
      get :show, :id => @post
    end

    should_respond_with :redirect
    should_redirect_to 'posts_path'
  end

  context "on GET to index for a guest user" do
    setup do
      get :index
    end
    should "display navigation for a guest user" do
      assert_select 'a[href=?]', new_session_path
      assert_select 'a[href=?]', new_admin_post_path, false
    end
  end
  
  context "on GET to index for a signed in user" do
    setup do
      sign_in_as Factory(:email_confirmed_user)
      get :index
    end
    should "display navigation for a guest user" do
      assert_select 'a[href=?]', new_admin_post_path
      assert_select 'a[href=?]', new_session_path, false
    end
  end
end
