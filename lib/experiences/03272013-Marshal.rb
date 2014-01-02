# encoding: utf-8
# 测试Marshal做缓存的速度，和用json做缓存比较
# --------------------------------------------------

# 1. 测试Marshal
# rails对象转成二进制字符串
#  str = Marshal.dump(object)
# 二进制字符串转成rails对象
#  object = Marshal.load(str)

# --------------------------------------------------

# 2. 测试Yajl
# Active_Record对象转成JSON字符串
#  user.serializable_hash.to_json
# JSON字符串转成Active_Record对象
#  attrs = Yajl::Parser.parse(resource)
#  user = User.new(attrs)

# 结论


require File.expand_path('../../../config/environment', __FILE__)


log_path = File.join(Rails.root, "log/Yajl.#{Time.now.to_i}.log")
logger = Logger.new(log_path)

sum = 500
result = []

resource = Marshal.dump(User.find('jeffrey6052'))

sum.times do |i|
    t = Time.now
    user = Marshal.load(resource)
    result << (Time.now - t)
    puts i
end

logger.info result.inspect.to_s

logger.info '-------------------------------------'

logger.info "共进行#{sum}次测试，#{n}次成功，#{sum}次失败"
logger.info "耗时平均值：#{result.reduce(:+)/n}"




