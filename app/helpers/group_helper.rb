module GroupHelper
	include SanitizeHelper

  def group_basic_info(group_id)
    #加入的状态
    @is_join = @current_uid && JoinedGroup.where(uid:@current_uid, group_id:group_id).select("id").first.present?

  end

end
