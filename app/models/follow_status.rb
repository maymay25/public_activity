class FollowStatus < ActiveRecord::Base
	self.table_name = 'follow_status'

	attr_accessible :uid, :nickname, :to_uid, :to_nickname


	
end
