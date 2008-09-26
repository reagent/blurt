xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'sneaq.'
    xml.description 'Stomping on a human face for 30 seconds at a time'
    xml.link root_url
    
    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.content.to_html
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link post.permalink
        xml.guid post.permalink
      end
    end
  end
end

