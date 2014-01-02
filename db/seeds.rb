# -*- encoding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def word(min,max)
    k = ("a".."z").to_a
    word = ""
    w_length = (min..max).to_a.sample
    w_length.times do |a|
      word += k.sample 
    end
    return word
end

def sentence(w_min,w_max,s_min,s_max)
  sentence = ""
  s_length = (s_min..s_max).to_a.sample
  s_length.times do |t|
    sentence += word(w_min,w_max)
    sentence += " "
  end
  return sentence
end

User.create(email:'jeffrey6052@163.com', nickname:'许其勇', username:'jeffrey6052', password:'hero2000',avatar_path:'/assets/avatars/jeffrey6052.jpg')
User.create(email:'carino0208@163.com', nickname:'乔布斯', username:'carino0208', password:'hero2000',avatar_path:'/assets/avatars/1.jpg')
User.create(email:'zhuxiaomei@163.com', nickname:'朱小梅', username:'zhuxiaomei', password:'hero2000',avatar_path:'/assets/avatars/2.jpg')
User.create(email:'zhangsan@163.com', nickname:'张三', username:'zhangsan', password:'hero2000',avatar_path:'/assets/avatars/3.jpg')
User.create(email:'lisi@163.com', nickname:'李四', username:'lisi', password:'hero2000',avatar_path:'/assets/avatars/4.jpg')
User.create(email:'zhaowu@163.com', nickname:'赵五', username:'zhaowu', password:'hero2000',avatar_path:'/assets/avatars/5.jpg')
User.create(email:'wangliu@163.com', nickname:'王六', username:'wangliu', password:'hero2000',avatar_path:'/assets/avatars/6.jpg')
