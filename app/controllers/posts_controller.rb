class PostsController < ApplicationController
  def index
    title.prepend Blurt.configuration.tagline
    @posts = Post.for_page(params[:page])
  end
  
  def show
    @post = Post.find_by_slug(params[:id])
    if @post
      title.prepend @post.title
    else
      redirect_to root_path and return
    end
  end

end
