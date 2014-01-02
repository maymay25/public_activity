# -*- coding:utf-8 -*-
require 'mime/types'

class UserController < ApplicationController

  skip_before_filter :verify_authenticity_token, only:[:upload_crop_avatar,:save_avatar]

  #关注用户 ajax
  def add_follow
    # params[:uid]
    return render_400 unless signed_in?

    return render_412 "uid" if params[:uid].nil?

    return render json:{res:false,msg:'不可以关注自己哦'}  if @current_uid==params[:uid].to_i

    user = User.where(id:params[:uid]).first
    return render json:{res:false,msg:'操作失败，该用户不存在'} if user.nil?

    follow = FollowStatus.where(uid:@current_uid, to_uid:user.id).select('id').first
    if follow.nil?
      FollowStatus.create(uid:@current_uid, nickname:@current_user.nickname, 
                          to_uid:user.id, to_nickname:user.nickname)
      flag = 'add'
    else
      flag = ''
    end

    return render json:{res:true,msg:'关注成功',flag:flag}
  end

  #取消关注用户 ajax
  def remove_follow
    # params[:uid]
    return render_400 unless signed_in?

    return render_412 "uid" if params[:uid].nil?

    follow = FollowStatus.where(uid:@current_uid, to_uid:params[:uid]).select('id').first
    if follow
      follow.destroy
      flag = 'reduce'
    else
      flag = ''
    end

    return render json:{res:true,msg:'',flag:flag}
  end

  #发送私信 ajax
  def chat
    # params[:uid] params[:content] 
    return render_400 unless signed_in?

    return render_412 "uid,content" if params[:uid].nil? or params[:content].blank?

    return render json:{res:false,msg:'不可以给自己发私信哦'}  if @current_uid==params[:uid].to_i

    u = User.where(id:params[:uid]).first
    return render json:{res:false,msg:'该用户不存在'} if u.nil?

    #避免连续两条相同的私信
    last_chat = Chat.where(uid:@current_uid, to_uid:u.id).select('content').order('created_at desc').first
    return render json:{res:false,msg:''}  if last_chat && last_chat.content==params[:content]

    chat = Chat.create(uid:@current_uid, to_uid:u.id, content:params[:content], 
                      has_read:true, is_in:false)

    #更新联系人信息
    linkman = Linkman.where(uid:u.id, to_uid:@current_uid).first
    if linkman
      linkman.update_attributes(no_read_count:linkman.no_read_count.to_i+1,
                    last_chat_at:chat.created_at,last_chat_content:chat.content)
    else
      Linkman.create(uid:u.id, to_uid:@current_uid,no_read_count:1,
                    last_chat_at:chat.created_at,last_chat_content:chat.content)
    end

    return render json:{res:true,msg:'私信发送成功'}
  end



  #上传预裁剪头像
  def upload_crop_avatar
    return render_400 unless signed_in?
    # params[:Filename] params[:Filedata]

    current_uid = @current_uid  # 根据uid缓存图片

    #TODO 用户缓存头像表
    cropUploader = AvatarCropUploader.new
    cropUploader.cache!(params[:Filedata])

    if cropUploader.cached?
      return render json:{cache_name:cropUploader.cache_name,img_src:cropUploader.thumb.url}
    else
      return render json:{msg:"上传失败，请稍候重试"}
    end
  end

  #保存用户头像
  def save_avatar
    return render_400 unless signed_in?
    if params[:cache_name]
      cropUploader = AvatarCropUploader.new
      cropUploader.retrieve_from_cache!(params[:cache_name])

      if cropUploader.cached?
        file = File.open(cropUploader.file.path,"r")

        #user = User.all.first
        user = @current_user
        user.crop_x = params[:crop_x].to_i
        user.crop_y = params[:crop_y].to_i
        user.crop_w = params[:crop_w].to_i
        user.crop_h = params[:crop_h].to_i
        user.crop_ow = params[:crop_ow].to_i
        user.crop_oh = params[:crop_oh].to_i
        user.avatar_path = file
        file.close
        user.save

        cropUploader.remove!

        1.percent_of_the_time do
          CarrierWave.clean_cached_files!(60*60)
        end

      end
    end
    redirect_to request.referer
  rescue
    file.close if file
    redirect_to request.referer
  end


  #保存用户头像 (图片url)
  def save_remote_avatar

    user = User.all.second
    user.remote_avatar_path_url = "http://news.baidu.com/z/resource/r/image/2013-10-10/07a38027d247bfac8cd1112335dc49e2.jpg"
    user.save

    1.percent_of_the_time do
      CarrierWave.clean_cached_files!(60*60)
    end

    render inline:'<img src="'+user.avatar_path.cover.url+'">'
  end


end
