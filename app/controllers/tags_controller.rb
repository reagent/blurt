class TagsController < ApplicationController
  def index
    @tags = Tag.by_name
  end

  def show
    @tag = Tag.find_by_slug(params[:slug])
    redirect_to tags_path and return if @tag.nil?
  end

end
