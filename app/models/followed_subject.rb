class FollowedSubject < ActiveRecord::Base
  attr_accessible :uid, :subject_id, :subject_title, :subject_identify

  paginates_per 20

end
