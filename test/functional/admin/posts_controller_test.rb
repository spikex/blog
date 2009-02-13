require 'test_helper'

class Admin::PostsControllerTest < ActionController::TestCase
  context "As as guest user" do
    should_deny_access_on "get :new"
    should_deny_access_on "post :create"
    should_deny_access_on "get :edit, {:id => 1}"
    should_deny_access_on "put :update, {:id => 1}"
  end
  
  context "As as signed in use" do
    setup do
      sign_in_as Factory(:email_confirmed_user)
    end
    context "on GET to new" do
      setup do
        get :new
      end

      should_respond_with :success
      should_render_template :new
      should_assign_to :post

      should "render navigation with a link to index" do
        assert_select 'div.navigation' do
          assert_select 'a[href=?]', posts_path
          assert_select 'a[href=?]', new_admin_post_path, :count => 0
        end
      end

      should "show a form to create a new post" do
        assert_select 'form[action=?][method=post]', admin_posts_path do
          assert_select 'input[type=text][name=?]', 'post[title]'
          assert_select 'input[type=text][name=?]', 'post[author]'
          assert_select 'textarea[name=?]', 'post[body]'
          assert_select 'input[type=checkbox][name=?]', 'post[published]'
          assert_select 'input[type=submit]'
        end
      end
    end

    context "on POST to create with valid post parameters" do
      setup do
        @post_count = Post.count
        post :create, :post => { :title => 'Test Title',  :body => 'Test Body' }
      end

      should_redirect_to "posts_path"
      should_set_the_flash_to /created/

      should "create a new post record" do
        assert_equal @post_count + 1, Post.count
      end

      should "create a post with the given title" do
        assert_not_nil post = Post.last
        assert_equal   'Test Title', post.title
      end
    end

    context "on POST to create with invalid post parameters" do
      setup do
        post :create, :post => {}
      end

      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash

      should "display error messages" do
        assert_select '#errorExplanation'
      end
    end

    context "on GET to edit" do
      setup do
        @post = Post.create({:title => 'Title', :body => 'Body'})
        get :edit, :id => @post
      end

      should_respond_with :success
      should_render_template :edit
      should_assign_to :post, :equals => '@post'

      should "show a form to edit a post" do
        assert_select 'form[action=?][method=post]', admin_post_path(@post) do
          assert_select 'input[type=text][name=?]', 'post[title]'
          assert_select 'input[type=text][name=?]', 'post[author]'
          assert_select 'textarea[name=?]', 'post[body]'
          assert_select 'input[type=checkbox][name=?]', 'post[published]'
          assert_select 'input[type=submit]'
        end
      end
    end

    context 'on PUT to update with valid parameters' do
      setup do
        @post = Factory(:post,:title => "Title", :body => "Body")
        @new_post_attributes = { :title => "New Title", :body => "New Body" }
        put :update, :id => @post, :post => @new_post_attributes
      end

      should_redirect_to "posts_path"
      should_set_the_flash_to /updated/

      should "update the post" do
        assert_equal "New Title", @post.reload.title
        assert_equal "New Body", @post.reload.body
      end
    end

    context 'on PUT to update with invalid parameters' do
      setup do
        @post = Factory(:post,:title => "Title", :body => "Body")
        put :update, :id => @post, :post => {:title => nil, :body => nil}
      end

      should_respond_with :success
      should_render_template :edit

      should "display error messages" do
        assert_select '#errorExplanation'
      end
    end
  end
end