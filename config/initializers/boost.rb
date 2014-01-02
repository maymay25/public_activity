
# 40.percent_of_the_time do
class Fixnum
  def percent_of_the_time(&block)
    raise(ArgumentError, 'Fixnum should be between 1 and 100 to be used with the times method') unless self > 0 && self <= 100
    yield if (Kernel.rand(99)+1) <= self
  end
end

# (3..6).times do
class Range
  def times(&block)
    Random.rand(self).times(&block)
  end
end

#中英文字符 长度验证 英文按照半个中文处理
class String

	def is_longer_than(sum)
		if self.length > sum and self.bytesize > 2*sum
			return true
		else
			return false
		end
	end

	def not_longer_than(sum)
		if self.length <= sum or self.bytesize <= 2*sum
			return true
		else
			return false
		end
	end
end

