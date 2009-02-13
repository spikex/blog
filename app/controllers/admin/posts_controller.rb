class Admin::PostsController < ApplicationController
  before_filter :authenticate

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

end