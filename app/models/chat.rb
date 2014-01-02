class Chat < ActiveRecord::Base
	attr_accessible :uid, :to_uid, :content, :has_read, :is_in

	paginates_per 20
	


	before_save do |r|
		@is_new_record = r.new_record?
	end

  after_save do |r|
  	if @is_new_record and r.is_in==false
  		Chat.create(uid:r.to_uid, to_uid:r.uid, content:r.content, has_read:false, is_in:true)
  	end
  end


end
