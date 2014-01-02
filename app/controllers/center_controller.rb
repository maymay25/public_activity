# -*- coding:utf-8 -*-
class CenterController < ApplicationController
	layout 'site2'
  include CenterHelper

  def index_page
  	#params[:uid]
  	@u = User.where(id:params[:uid]).first
    return render '404' if @u.nil?

    #订阅的专题
    all_follow_relations = FollowedSubject.where(uid:@u.id)
    @followed_subjects = all_follow_relations.order('created_at desc').limit(7)
    @followed_subjects_sum = @followed_subjects.length>0 ? all_follow_relations.count : 0

    user_basic_info(@u.id)
  end

  #Ta喜欢的文章
  def favorite_page
  	#params[:uid]
  	@u = User.where(id:params[:uid]).first
    return render '404' if @u.nil?

  	@favorite_posts = FavoritePost.where(uid: @u.id).order("created_at desc").page(params[:page])

    if @favorite_posts.length>0
      subject_ids = @favorite_posts.collect{|f| f.subject_id }.uniq
      subjects = Subject.where(id: subject_ids)
      @subjects = {}
      subjects.each do |subject|
        @subjects[subject.id] = subject
      end
    end

    user_basic_info(@u.id)
  end

  #Ta的评论
  def comment_page
  	#params[:uid]
  	@u = User.where(id:params[:uid]).first
    return render '404' if @u.nil?

  	@comments = SubjectPostComment.where(uid:@u.id).order("created_at desc").page(params[:page]).per(20)
    
    if @comments.length>0
      subject_ids = @comments.collect{|c| c.subject_id }.uniq
      subjects = Subject.where(id: subject_ids)
      @subjects = {}
      subjects.each do |subject|
        @subjects[subject.id] = subject
      end
    end
    
    user_basic_info(@u.id)
  end

  #Ta关注的专题
  def subject_page
    #params[:uid]
    @u = User.where(id:params[:uid]).first
    return render '404' if @u.nil?

    all_follow_relations = FollowedSubject.where(uid:@u.id)
    @followed_subjects = all_follow_relations.order('created_at desc').page(params[:page]).per(40)
    @followed_subjects_sum = @followed_subjects.length>0 ? all_follow_relations.count : 0

    user_basic_info(@u.id)
  end

  #Ta的关注
  def follow_page
    #params[:uid]
    @u = User.where(id:params[:uid]).first
    return render '404' if @u.nil?

    @follow_relations = FollowStatus.where(uid:@u.id).select('id,to_uid').order('id desc').page(params[:page]).per(40)

    if @follow_relations.length>0
      uids = @follow_relations.collect{|f| f.to_uid }
      @follow_users = User.where(id:uids)
    end

    user_basic_info(@u.id)
  end

  #Ta的粉丝
  def fans_page
    #params[:uid]
    @u = User.where(id:params[:uid]).first
    return render '404' if @u.nil?

    @follow_relations = FollowStatus.where(to_uid:@u.id).select('id,uid,to_uid').order('id desc').page(params[:page]).per(40)

    if @follow_relations.length>0
      uids = @follow_relations.collect{|f| f.uid }
      @fans_users = User.where(id:uids)
    end

    user_basic_info(@u.id)
  end


  def center_demo
    @u = User.where(id:params[:uid]).first
    return render '404' if @u.nil?
    
    user_basic_info(@u.id)
  end
  

end
