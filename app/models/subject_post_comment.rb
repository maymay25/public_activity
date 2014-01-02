class SubjectPostComment < ActiveRecord::Base
	attr_accessible :post_id, :post_title, :uid, :nickname,
									:subject_id, :subject_title, :subject_identify,
									:content, :is_verify, :is_public

	paginates_per 50


  include PublicActivity::Model
  tracked

end
