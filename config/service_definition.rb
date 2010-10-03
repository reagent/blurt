authentication do |username, password|
  username == Blurt.configuration.username && password == Blurt.configuration.password
end

service :metaWeblog do
  
  method :newPost do |blog_id, username, password, struct, publish_flag|
    authenticate username, password
    
    post = Post.create!(
      :title     => struct['title'],
      :body      => struct['description'],
      :tag_names => struct['categories']
    )
    post.id.to_s
  end
  
  method :getPost do |id, username, password|
    authenticate username, password
    to_struct(:post, Post.find(id))
  end
  
  method :editPost do |id, username, password, struct, publish_flag|
    authenticate username, password
    
    post = Post.find(id)
    post.update_attributes(
      :title     => struct['title'],
      :body      => struct['description'],
      :tag_names => struct['categories']
    )
  end
  
  method :getRecentPosts do |blog_id, username, password, limit|
    authenticate username, password
    Post.by_date.with_limit(limit).map {|p| to_struct(:post, p) }
  end
  
  method :getCategories do |blog_id, username, password|
    authenticate username, password
    Tag.by_name.map {|t| to_struct(:tag, t) }
  end

  method :newMediaObject do |blog_id, username, password, struct|
    authenticate username, password
    
    media = Media.new(struct)
    media.save!
  
    media.to_struct
  end
  
  struct :post do |post|
    {
      :postid      => post.id.to_s,
      :title       => post.title,
      :categories  => post.tag_names,
      :permaLink   => post.permalink,
      :description => post.body,
      :dateCreated => post.created_at
    }
  end
  
  struct :tag do |tag|
    {
      :description => tag.name,
      :htmlUrl     => '',
      :rssUrl      => ''
    }
  end
  
end

service :mt do
  
  method :getCategoryList do |blog_id, username, password|
    authenticate username, password
    Tag.by_name.map {|t| to_struct(:tag, t) }
  end
  
  method :getPostCategories do |post_id, username, password|
    authenticate username, password
    
    post = Post.find(post_id)
    post.tags.by_name.map {|tag| to_struct(:extended_tag, tag) }
  end
  
  method :setPostCategories do |post_id, username, password, categories|
    authenticate username, password
    
    post = Post.find(post_id)
    post.tag_names = categories
    post.save!
  end
  
  method :publishPost do |post_id, username, password|
    authenticate username, password
    Post.find(post_id).touch
  end
  
  method :getRecentPostTitles do |blog_id, username, password, limit|
    authenticate username, password
    Post.by_date.with_limit(limit).map {|p| to_struct(:post, p) }
  end
  
  # method :supportedMethods do
  # end
  
  # TODO: 
  # def getTrackbackPings(post_id)
  #   []
  # end
  # 
  # def supportedTextFilters
  #   [{:key => 'markdown', :label => 'Markdown'}]
  # end
  
  struct :tag do |tag|
    {
      :categoryId   => tag.id.to_s,
      :categoryName => tag.name
    }
  end
  
  struct :extended_tag do |tag|
    {
      :categoryId   => tag.id.to_s,
      :categoryName => tag.name,
      :isPrimary    => false
    }
  end
  
  struct :post do |post|
    {
      :postid      => post.id.to_s,
      :userid      => '1',
      :title       => post.title,
      :dateCreated => post.created_at
    }
  end
  
end
