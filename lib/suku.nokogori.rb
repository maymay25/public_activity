# encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'cgi'

#require File.expand_path('../../config/environment', __FILE__)

# unicode乱码转成中文
def unicode_utf8(unicode_string)
  unicode_string.gsub(/\\u\w{4}/) do |s|
    str = s.sub(/\\u/, "").hex.to_s(2) 
    if str.length < 8 
        CGI.unescape(str.to_i(2).to_s(16).insert(0, "%")) 
    else
        arr = str.reverse.scan(/\w{0,6}/).reverse.select{|a| a != ""}.map{|b| b.reverse} 
        hex = lambda do |s| 
          (arr.first == s ? "1" * arr.length + "0" * (8 - arr.length - s.length) + s : "10" + s).to_i(2).to_s(16).insert(0, "%") 
        end
        CGI.unescape(arr.map(&hex).join) 
    end
  end
end

#将javascript escape('xxx') 生成的字符串转成正常的中文字符串
def js_unicode_utf8(str)
  unicode_str = CGI.unescape(str).gsub('%u','\\u')
  unicode_utf8(unicode_str)
end

def fetch_suku_source(url)
  doc = Nokogiri::HTML(open(url))
  doc_keywords = doc.css('meta[name=keywords]')
  doc_playdata = doc.css('div.videobox .playbox .player script')

  sp = "在线观看提供"
  if doc_keywords.first.nil? or doc_keywords.first['content'].nil? or !doc_keywords.first['content'].include?(sp)
    return
  end
  if doc_playdata.first.nil? or doc_playdata.first['src'].nil?
    return
  end
  title = doc_keywords.first['content'].split(sp)[0]
  #puts title
  #root = url.scan(/http:\/\/.*?\//).first
  root = "http://" + url[7..-1].split("/")[0]
  # puts root
  playdata_url = root + doc_playdata.first['src'].split('?')[0]
  #puts playdata_url
  doc2 = Nokogiri::HTML(open(playdata_url))
  playlist_str = doc2.css('body p').first.content.scan(/unescape\('.*?'\);/).first[9..-4]
  playlist_source = js_unicode_utf8(playlist_str)
  #puts playdata
  return {title:title,playlist_source:playlist_source}
end

def decode_suku_source(source)
  video_title = source[:title]
  playlist_source = source[:playlist_source]
  resource_type,resource_list = playlist_source.split('$$')
  source_list = resource_list.split('#')
  yy_source = []
  source_list.each do |r|
    h = {}
    title,url,type = r.split('$')
    h[:video_title] = video_title
    h[:title] = title
    h[:url] = url
    h[:type] = type
    yy_source << h
  end
  return yy_source
end

# source = fetch_suku_source("http://www.suku.cc/film50/3821/play-0-0.html")

# puts decode_suku_source(source)

#抓取suku的影片图片
def fetch_suku_img(url)
  return nil if url.nil? or !url.include?('suku.cc')
  doc = Nokogiri::HTML(open(url))

  doc_pic = doc.css('p.pic').css('img').first['src']

  if doc_pic.nil? or doc_pic.class!=String or !url.include?('http://')
    return
  end

  return doc_pic
end

#p fetch_suku_img('http://www.suku.cc/film49/3870/')

p fetch_suku_img('http://www.suku.cc/film18/4681/')


# {:video_title=>"\u4E24\u4E2A\u7238\u7238/2\u4E2A\u7238\u7238", :title=>"\u7B2C41
# \u96C6", :url=>"bdhd://272030131|D8B28A09CFA53A5B67E3D3170BC6363D|2\u4E2A\u7238\
# u723841.rmvb", :type=>"bdhd"}

# Do funky things with it using Nokogiri::XML::Node methods...

####
# Search for nodes by css
# doc.css('h3.r a').each do |link|
#   puts link.content
# end

# ####
# # Search for nodes by xpath
# doc.xpath('//h3/a').each do |link|
#   puts link.content
# end

# ####
# # Or mix and match.
# doc.search('h3.r a.l', '//h3/a').each do |link|
#   puts link.content
# end