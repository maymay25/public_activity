class SubjectPost < ActiveRecord::Base
  attr_accessible :comment_sum, :content, :cover_path, :subject_id, 
  								:subject_title, :summary, :tags, :title, :view_sum,
  								:created_at, :subject_identify, :content_type, :embed_summary, :favorite_sum
  
  mount_uploader :cover_path, CoverUploader

  has_many :subject_post_tags, class_name: 'SubjectPostTags', foreign_key: 'post_id', dependent: :destroy
  has_many :subject_post_comments, foreign_key: 'post_id', dependent: :destroy
  has_many :favorite_posts, foreign_key: 'post_id', dependent: :destroy
  has_many :activities, class_name: "Activity", as: :recipient

  paginates_per 10

  #content_type  0.普通 1.视频 2.虾米音乐
  TYPE = {normal:0,video:1,audio:2}

  after_destroy do |r|
  	#puts "#{Time.now} | SubjectPost after_destroy active"
  end

end
