class PostsController < ApplicationController
  def index
    @posts = Post.for_page(params[:page])
  end
  
  def show
    @post = Post.find_by_slug(params[:id])
    redirect_to root_path if @post.nil?
  end

end
