class Linkman < ActiveRecord::Base
  attr_accessible :uid, :to_uid, :no_read_count, :last_chat_at, :last_chat_content

  paginates_per 10

end
