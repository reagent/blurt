class SitemapController < ApplicationController
  def show
    @sitemap = Sitemap.new

    respond_to do |wants|
      wants.xml { render :xml => @sitemap.to_xml }
    end
  end

end
