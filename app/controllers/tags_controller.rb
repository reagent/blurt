class TagsController < ApplicationController
  def index
    title.prepend 'tags'
    @tags = Tag.by_name
  end

  def show
    @tag = Tag.find_by_slug(params[:slug])
    if @tag
      title.prepend 'tags', @tag.name
    else
      redirect_to tags_path and return
    end
  end

end
