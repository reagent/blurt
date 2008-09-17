module Formatter
  
  class Code
    
    def initialize(content)
      @raw_content = content
    end
    
    def to_html
      doc = Hpricot(@raw_content)
      (doc/'code').each do |node|
        node.swap CodeRay.scan(node.inner_text, node['lang']).div
      end
      
      BlueCloth.new(doc.to_html).to_html.strip
    end
    
    def to_s
      @raw_content
    end
    
  end
  
end