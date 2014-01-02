#encoding: utf-8
#删除指定id的subject
#警告：该操作不可逆
require File.expand_path('../../../config/environment', __FILE__)

def destroy_subject(id)
	id = id.to_i
	return puts "need params : id" if id<1
	subject = Subject.where(id:id).first
	return puts "not exist" if subject.nil?
	subject.destroy
	puts "success. finish."
end

subject_id = ARGV.first



destroy_subject(subject_id)






