#encoding: utf-8
#蜘蛛爬取suku.cc的资源

require 'anemone'

require File.expand_path('../../../config/environment', __FILE__)

#all_reg = /^http:\/\/www.suku.cc\/film([0-9]*)(\/index[0-9]*.html)?(\/[0-9a-zA-Z_]*)?(\/)?$/

all_reg = /^http:\/\/www.suku.cc\/film([0-9]*)(\/)?(?!play\-).*$/

source_reg = /^http:\/\/www.suku.cc\/film([0-9]*)\/([0-9a-zA-Z_]*)(\/)?$/

Anemone.crawl("http://www.suku.cc/") do |anemone|

	 anemone.on_pages_like(all_reg) do |page|

	 crawl_url = page.url.to_s

	 next unless crawl_url == crawl_url.match(source_reg).to_s
	 
	 url = page.url.to_s + 'play-0-0.html'

	 if YySukuUrl.find_by_url(url).nil?
	 	YySukuUrl.create(url:url)
	 	puts url
	 	puts "---------------------------------------------"
	 end

	end

end

# url = 'http://www.suku.cc/film17/xingjimihangzhishijinheian/1'

# puts url == url.match(/^http:\/\/www.suku.cc\/[^\/]*\/[^\/]*\/$/).to_s




