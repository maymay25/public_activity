# -*- coding:utf-8 -*-
class MyController < ApplicationController
	layout 'site2'
	include CenterHelper

  before_filter :require_login

  #我的私信
  def message_page
    return render_404 unless signed_in?

    @u = @current_user

    @linkmans = Linkman.where(uid:@u.id).page(params[:page])

    uids = @linkmans.collect{ |l| l.to_uid }
    @users = {}
    if uids.length>0
      User.where(id:uids).each do |u|
        @users[u.id] = u
      end
    end

    user_basic_info(@u.id)
  end

  #私信历史
  def message_history_page
    #params[:uid]
    return render_404 unless signed_in?

    return render_412 "uid" if params[:uid].nil?

    @u = @current_user

    @u2 = User.where(id:params[:uid]).first
    return render_404 "该用户不存在" unless @u2.present?

    @chats = Chat.where(uid:@u.id, to_uid:@u2.id).order('created_at desc').page(params[:page])

    user_basic_info(@u.id)
    
  end
end
