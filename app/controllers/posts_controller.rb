class PostsController < ApplicationController
  before_filter :ensure_published, :only => 'show'

  def index
    @posts = Post.latest
    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  private

  def ensure_published
    post = Post.find(params[:id])
    redirect_to posts_path unless post.published?
  end
end
