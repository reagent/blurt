class PostsController < ApplicationController
  def index
    @posts = Post.by_date
  end

end
