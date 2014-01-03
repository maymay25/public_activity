class Subject < ActiveRecord::Base
  attr_accessible  :title, :intro, :cover_path, :post_sum, :tag_sum, :identify

  mount_uploader :cover_path, CoverUploader

  validates :title, :uniqueness => true,:length=>{:within=>2..12}, presence: true
  validates :identify, :length=>{:within=>2..15}, :format => { :with => /[a-zA-Z0-9_]*/i },
  										:uniqueness => true, presence: true
  validates :cover_path, presence: true

  has_many :subject_posts, dependent: :destroy
  has_many :subject_tags, class_name: 'SubjectTags', dependent: :destroy
  has_many :followed_subjects, dependent: :destroy

  has_many :activities, class_name: "SubjectActivity", as: :recipient

  paginates_per 10

end
