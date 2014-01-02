module CenterHelper
	
  def user_basic_info(uid)
    #用户的关注状态
    @is_follow = @current_uid && @current_uid!=uid && FollowStatus.where(uid:@current_uid, to_uid:uid).select('id').first.present?

    #计数统计
    @user_comment_sum = SubjectPostComment.where(uid:@u.id).select('id').count
    @user_favorite_sum = FavoritePost.where(uid: @u.id).select('id').count
    @user_follow_sum = FollowStatus.where(uid:@u.id).select('id').count
    @user_fans_sum = FollowStatus.where(to_uid:@u.id).select('id').count
  end

end
