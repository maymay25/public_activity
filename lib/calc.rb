# encoding: utf-8

#二进制字符串转成10进制整数
# def toInteger(str)
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

# puts toInteger('111')  # 7
# puts toInteger('1111')  # 15
# puts toInteger('11111111') # 255

puts "-------------测试16进制数---------------"
puts "0xc6a4a7935bd1e995"
# -4132994306676758123



a = 0xc6a4a7935bd1e995


puts a

str = a.to_s(2).rjust(64,'0')

# puts str.length
# puts str

#puts str.to_i(2)


if str[0]=='1'
	x = -1
else
	x = 1
end
puts str
a = str[1..-1]
puts a
b = a.to_i(2)
#puts b
c = b.to_s(2)
puts c

puts x*b

# puts "-------------测试异或---------------"


# x1 = '100101010101'
# x2 = '011000000000'

# puts x1
# puts x2

# y1 = toInteger(x1)
# y2 =toInteger(x2)

# puts (y1 ^ y2).to_s(2)







