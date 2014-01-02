
require 'anemone'

Anemone.crawl("http://www.ifanr.com/") do |anemone|

  #anemone.on_every_page { |page| titles.push page.doc.at('title').inner_html rescue nil }

  i = 0 ;

	anemone.on_pages_like(/http:\/\/www.ifanr.com\/\d+/) do |page|
	 url = page.url
	 _doc = page.doc
	 title = _doc.at('title').inner_html rescue nil
	 article = _doc.at('article.entry-common').inner_html rescue 'failure'

	 i += 1
	 puts "#{url} #{title}"
	 puts "#{article}" 
	 break if i>10
	end

end




