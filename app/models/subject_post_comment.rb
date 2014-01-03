class SubjectPostComment < ActiveRecord::Base

	attr_accessible :post_id, :post_title, :uid, :nickname,
									:subject_id, :subject_title, :subject_identify,
									:content, :is_verify, :is_public

	paginates_per 50


  def create_activity(r)
    parameters = {}
    Activity.create(trackable_id:r.id, trackable_type:'SubjectPostComment', 
                    owner_id:r.uid, owner_type:'User', 
                    recipient_id:r.post_id, recipient_type:'SubjectPost',
                    key:'SubjectPostComment#create', parameters:parameters)
    SubjectActivity.create(trackable_id:r.id, trackable_type:'SubjectPostComment', 
                    owner_id:r.uid, owner_type:'User', 
                    recipient_id:r.subject_id, recipient_type:'Subject',
                    key:'SubjectPostComment#create', parameters:parameters)
  end

  def destroy_activity(r)
    activity = Activity.where(trackable_id:r.id, trackable_type:'SubjectPostComment')
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
