class FavoriteGroupTopic < ActiveRecord::Base

	attr_accessible :uid, :topic_id, :topic_title, :topic_summary,
									:group_id, :group_name, :group_title

end
