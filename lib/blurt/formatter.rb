module Blurt
  
  class Formatter
    
    def initialize(content)
      @raw_content = content
    end
    
    def to_html
      html = BlueCloth.new(@raw_content).to_html
      
      # find nodes that might be formattable code
      doc = Hpricot(html)
      (doc/'pre/code').each do |node|
        lang = nil
        lines = node.inner_text.split("\n")
        if (matches = lines.first.match(/^#lang:(\w+)$/))
          lang = matches[1]
          lines.shift
        end
        
        if lang
          node.parent.swap CodeRay.scan(lines.join("\n"), lang).div
        end
      end
      
      doc.to_html.strip
    end
    
    def to_s
      @raw_content
    end
    
  end
  
end