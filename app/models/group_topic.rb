class GroupTopic < ActiveRecord::Base

	attr_accessible :title, :uid, :summary, :content,
									:group_id, :group_title, :group_name, :favorite_sum

  validates :title, presence: true
  validates :content, length: { maximum: 20000 }, presence: true
  validates :summary, presence: true

end
