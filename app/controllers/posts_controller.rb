class PostsController < ApplicationController
  before_filter :ensure_published, :only => 'show'

  def index
    @posts = Post.all(:order => 'created_at desc')
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      flash[:success] = 'Your post has been created.'
      redirect_to posts_path
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:success] = 'Your post has been updated.'
      redirect_to posts_path
    else
      render :action => 'edit'
    end
  end

  private

  def ensure_published
    post = Post.find(params[:id])
    redirect_to posts_path unless post.published?
  end
end
