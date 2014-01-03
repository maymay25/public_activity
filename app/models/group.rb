class Group < ActiveRecord::Base

	attr_accessible :title, :name, :intro, :member_sum, :cover_path

	mount_uploader :cover_path, CoverUploader

  validates :title, :uniqueness => true,:length=>{:within=>2..20}, presence: true
  validates :name, :length=>{:within=>2..30}, :format => { :with => /[a-zA-Z0-9_]*/i },
  										:uniqueness => true, presence: true
  validates :cover_path, presence: true

  has_many :group_topics, dependent: :destroy


end
