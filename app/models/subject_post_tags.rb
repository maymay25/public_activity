class SubjectPostTags < ActiveRecord::Base
  attr_accessible :post_id, :subject_id, :tag
end
