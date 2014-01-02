
class Base
	
end

module Extra
	
	def self.included(c)
		c.extend(ClassMethods)
	end
  
	def aaaaa
		puts 'find me in Extra::aaaaa'
	end
	
	protected :aaaaa
	
	module ClassMethods
		def bbbbb
			puts 'find me in Extra::ClassMethods::bbbbb'
		end
	end
	
	
	
end

Base.send :include,Extra


class Work < Base

	bbbbb
	
	def test	
		work = Work.new
		work.aaaaa
	end
end

w = Work.new
w.test




