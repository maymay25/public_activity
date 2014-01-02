# encoding: utf-8

# /^http:\/\/www.suku.cc\/film([0-9]*)\/([0-9a-zA-Z_]*)(\/)?$/

# puts RUBY_PLATFORM

#p Integer.max

#p [nil].compact.uniq

# p nil.present?

# p ''.present?

# p '  '.present?

# a,b,c,d = 1,2,3,4,5

# puts a
# puts b
# puts c
# puts d


# default_path = false

# puts default_path

# class Klass

# 	@xunch_flag = false

# 	def self.update_xunch_flag
# 		@xunch_flag = true
# 	end

#   def self.hello
#   	p @xunch_flag
#   	if @xunch_flag==false
#   		"default hello"
# 	  else
# 	  	"xunch hello"
# 	  end

#   end

# end


# Klass.send :update_xunch_flag

# puts Klass.hello

# module ABC
# 	class Film

# 		def initialize
# 			@abc = 1
# 			@def = '234'
# 		end

# 		ABC = 123

# 		def test
# 			1111
# 		end

# 	end

# end

# film = ABC::Film.new

# p film.class.to_s



# puts "".empty?
# puts [].empty?

# puts Time.now.to_s

# p 0.zero?

# p 1.zero?

#p Time.now

#'2013-10-22 15:18:38 +0800'

# puts "许其勇许bc勇".is_small_than(6)

# puts "abcabcabcabc".is_small_than(6)


# arr1 =  ['a','b','c','d','e']
# arr2 = [1,2,3,4,5]

# together = [arr1,arr2]

# p together.transpose



# def test(*arr)
# p arr.length

# p arr[1]

# p arr[5]

# p arr[8]

# end


# test 1,2,3,4,5,6




# a = 1
# puts a

# def test(&a)
# 	a = &a
# 	a = 2
# end

# puts a


# def test(argu1,&block)
# puts argu1
# a = 1
# b = 2

# p block

# if(block)
# 	test2(block)
# end
# end

# def test2(block)
# a = 1
# b = 2
# block.call(a,b)
# end


# def block1
# 	lambda do |x,y|
# 		x + y
# 	end
# end

# test(block1)

#num = 10


# lamb =lambda do |x,y|
# 		x + y
# 	end


# proc = Proc.new do |a,b|
# 	a + b
# end

# def test(&proc)
# 	x,y = 3,5
# 	proc.call x,y
# end

#test(&num)

# def do_some_thing(x,y,&callback)
# 	result = Math.sqrt(x**2 + y**2)
# 	if callback
# 		callback.call(result)
# 	else
# 		"default result : #{result}"
# 	end
# end

# x = 3
# y = 4

# puts do_some_thing(x,y)
# # => default result : 5.0

# puts do_some_thing(x,y,&Proc.new{|result|
# 	"callback result : #{result*2}"
# })
# => callback result : 10.0





# def regex_test(str,reg=nil)
#   return nil if reg.nil?
#   return str == str.match(reg).to_s
# end

#   def ie6?
#       @is_ie6 ||= 'msie 6'.match(/(?i)msie [1-6]/) ? 1 : 0
#       @is_ie6 > 0
#   end

# puts ie6?

#puts "00000000000000000000000003A1AF99".length

#p ["nonce","timestemp","token"].sort.join("")

#p 1.to_f


#p "123"[5..-1]

#二进制字符串转成10进制整数
# def switch(str)
# 	length = str.length
# 	result = 0
# 	index = 0
# 	str.each_char do |n|
# 		if n.to_i==1
# 			result += 2**(length-index-1)
# 		end
# 		index += 1
# 	end
# 	return result
# end

# str =  0xC23ABC.to_s(2)

# if str[0]=='1'
# 	x = -1
# else
# 	x = 1
# end

# a = str[1..-1]
# puts a
# b = switch(a)
# puts b
# c = b.to_s(2)
# puts c

# puts x*b


# a1 = switch '100101010101'
# a2 = switch '011000000000'

# puts a1.to_s(2)
# puts a2.to_s(2)
# puts (a1 ^ a2).to_s(2)






#p [1]+[2,3,4]

#p [1][1..-1]

# all_reg = /^http:\/\/www.suku.cc\/film([0-9]*)(\/index[0-9]*.html)?(\/[0-9a-zA-Z_]*)?(\/)?$/

# source_reg = /^http:\/\/www.suku.cc\/film([0-9]*)\/([0-9a-zA-Z_]*)(\/)?$/

# puts regex_test('http://www.suku.cc/film25/lianggebaba/play-0-1.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/lianggebaba',all_reg)
# puts regex_test('http://www.suku.cc/film25/lianggebaba/',all_reg)

# puts regex_test('http://www.suku.cc/film25/',all_reg)

# puts regex_test('http://www.suku.cc/film25/index.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/index1.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/index33.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/index3a3.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/hh.html',all_reg)


# all_reg = /^http:\/\/www.suku.cc\/film([0-9]*)\/(?!play\-).*$/

#reg = /^(?!play\-).*/

# puts regex_test('http://www.suku.cc/film25/index33.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/index3a3.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/hh.html',all_reg)

# puts regex_test('http://www.suku.cc/film25/play-0-3.html',all_reg)

#puts str.bytesize






