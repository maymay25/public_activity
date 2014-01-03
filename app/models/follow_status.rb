class FollowStatus < ActiveRecord::Base
	self.table_name = 'follow_status'

	attr_accessible :uid, :nickname, :to_uid, :to_nickname

  def create_activity(r)
    parameters = {}
    Activity.create(trackable_id:r.to_uid, trackable_type:'User', 
                    owner_id:r.uid, owner_type:'User', 
                    key:'FollowStatus#create', parameters:parameters)
  end

  def destroy_activity(r)
    activity = Activity.where(trackable_id:r.to_uid, trackable_type:'User', owner_id:r.uid, owner_type:'User', key:'FollowStatus#create')
    activity.delete_all
  end

  before_save do |r|
    @is_new_record = r.new_record?
  end

  after_save do |r|
    create_activity(r) if @is_new_record
  end


  before_destroy do |r|

  end

  after_destroy do |r|
    destroy_activity(r)
  end
	
end
