class FavoritePost < ActiveRecord::Base
	attr_accessible :post_id, :post_title, :uid, :nickname,
									:subject_id, :subject_title, :subject_identify,
									:summary, :content_type, :embed_summary

	paginates_per 20


end
