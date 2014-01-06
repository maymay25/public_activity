# -*- coding:utf-8 -*-
class GroupController < ApplicationController
  include GroupHelper

  layout 'site2'

  def index
  end

  def topic_list
    @group = Group.where(name:params[:name]).first
    return render_404 if @group.nil?
    @topics = GroupTopic.where(group_name:@group.name).order('created_at desc').page(params[:page]).per(50)
    
    #p @topics.length

    group_basic_info(@group.id)
  end

  def topic
    @topic = GroupTopic.where(id:params[:topic_id]).first
    return render_404 if @topic.nil?
    return redirect_to "/group/#{@topic.group_name}/#{@topic.id}" if @topic.group_name!=params[:name]
    group_basic_info(@topic.group_id)
  end

  def new
    return redirect_to "/",notice:'需要管理员权限' unless admin?
  end

  def new_topic
    @group = Group.where(name:params[:name]).first
    return render_404 if @group.nil?
    return redirect_to "/group/#{@group.name}" unless signed_in?
    group_basic_info(@group.id)
  end

  #创建新的小组
  def create
    return redirect_to "/",notice:'需要管理员权限' unless admin?
    group = Group.new
    group.title = params[:title]
    group.name = params[:name]
    group.intro = sanitize_link_intro(params[:intro])
    group.cover_path = params[:cover_path]
    if group.valid?
      group.save
      redirect_to "/group/#{group.name}",notice:"创建成功"
    else
      redirect_to request.referer,notice:"创建失败 --- #{group.errors.inspect}"
    end
  end

  #创建话题
  def create_topic
    return render_400 unless signed_in?
    return render_412 "title,content,summary" if params[:title].blank? or params[:content].blank? or params[:summary].blank?
    @group = Group.where(name:params[:name]).first
    return render_404 "该小组不存在" if @group.nil?
    init_content = sanitize_content(params[:content])
    topic = GroupTopic.new
    topic.title = params[:title]
    topic.content = init_content
    topic.summary = params[:summary]
    topic.uid = @current_uid
    topic.group_id = @group.id
    topic.group_title = @group.title
    topic.group_name = @group.name
    if topic.valid?
      topic.save
      return render json:{res:true,msg:'创建成功',redirect:"/group/#{topic.group_name}/#{topic.id}"}
    else
      return render_500 "创建失败 --- #{topic.errors.inspect}"
    end
  end

  #加入小组 ajax
  def join_group
    # params[:post_id]
    return render_400 unless signed_in?
    return render_412 "group_id" if params[:group_id].nil?
    group = Group.where(id:params[:group_id]).first
    return render json:{res:false,msg:'操作失败，相关内容已经不存在'} if group.nil?
    join = JoinedGroup.where(uid:@current_uid, group_id:group.id).first
    if join.nil?
      JoinedGroup.create(uid:@current_uid, group_id:group.id, group_title:group.title, group_name:group.name)
      member_sum = group.member_sum.to_i+1
      group.update_attributes(member_sum:member_sum)
      flag = 'join'
    else
      member_sum = group.member_sum.to_i
      flag = ''
    end
    render json:{res:true,msg:'加入成功',flag:flag,member_sum:member_sum}
  end

  #退出小组 ajax
  def quit_group
    # params[:post_id]
    return render_400 unless signed_in?
    return render_412 "group_id" if params[:group_id].nil?
    group = Group.where(id:params[:group_id]).first
    join = JoinedGroup.where(uid:@current_uid, group_id:params[:group_id]).first
    if join
      join.destroy
      if group
        oriCount = group.member_sum.to_i
        member_sum = oriCount > 1 ? oriCount-1 : 0
        group.update_attributes(member_sum: member_sum)
      else
        member_sum = 0
      end
      flag = 'quit'
    else
      member_sum = group ? group.member_sum.to_i : 0
      flag = ''
    end
    render json:{res:true,msg:'退出成功',flag:flag,member_sum:member_sum}
  end

end
