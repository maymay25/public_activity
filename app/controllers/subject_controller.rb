# -*- coding:utf-8 -*-
class SubjectController < ApplicationController
	layout 'site2'
  include SubjectHelper

  def test
    content = "<p></p>gr</div>ewe wfwefew<p><img src='abc' alt='def'><div><img src='abc' alt='def'><img src='abc' alt='def'>fwe erge fw efw ergwe f wefwefe wfefew<img src='abc' alt='def'><img src='abc' alt='def'>"
    #result = sanitize_three_img(content)

    result = sanitize_content(content)
    puts result

    render text:result
    #render layout: false
  end


  def index
    @subjects = Subject.order('created_at desc').page(params[:page]).per(6)

    @subject_posts = {}
    if @subjects.length > 0
      subject_ids = @subjects.collect{|s| s.id }
      subject_ids.each do |subject_id|
        @subject_posts[subject_id] = SubjectPost.where(subject_id:subject_id).where(is_publish:true).order('created_at desc').limit(6)
      end
    end

    @develop = true
  end

  def new
    
  end

  #创建新的专题
  def create
    subject = Subject.new
    subject.title = params[:title]
    subject.identify = params[:identify]
    subject.intro = params[:intro]
    subject.cover_path = params[:cover_path]

    if subject.valid?
      subject.save
      flash[:succ] = "创建成功"
      return redirect_to "/subject/#{subject.identify}"
    else
      flash[:error] = "创建失败"
      return redirect_to request.referer
    end
  end

  def post_list
    @subject = Subject.where(identify:params[:identify]).first
    return render '404' if @subject.nil?
    @posts = SubjectPost.where(subject_identify:@subject.identify).where(publish_condition).order('created_at desc').page(params[:page]).per(10)
    subject_sidebar @subject.id
  end

  def tag_post_list

    init_tag = params[:tag].to_s.strip
    init_id = params[:id].to_i
    return render '404' if init_tag.empty? or init_id.zero?

    @subject = Subject.where(id:init_id).first
    return render '404' if @subject.nil?

    subject_tag = SubjectTags.where(subject_id:init_id,tag:init_tag).first
    return render '404' if subject_tag.nil?

    post_tags_relations = SubjectPostTags.where(subject_id:init_id, tag:init_tag).order('post_id desc').page(params[:page]).per(10)

    @posts_sum = post_tags_relations.count

    post_ids = post_tags_relations.collect{|r| r.post_id }
    @posts = SubjectPost.where(id:post_ids).where(publish_condition).order('id desc')

    @paginate_list = post_tags_relations

    subject_sidebar init_id
  end

  def post
    @post = SubjectPost.where(id:params[:post_id]).where(publish_condition).first
    return render '404' if @post.nil?

    return redirect_to "/subject/#{@post.subject_identify}/#{@post.id}" if @post.subject_identify!=params[:identify]

    @subject = Subject.where(identify:params[:identify]).first
    return render '404' if @subject.nil?

    #post的浏览次数 +1
    @post.view_sum = @post.view_sum.to_i + 1
    @post.save

    #上一条 下一条
    @pre_post = SubjectPost.where(is_publish:true, subject_id:@subject.id).where(["created_at > ?", @post.created_at ]).order('created_at asc').first
    @next_post = SubjectPost.where(is_publish:true, subject_id:@subject.id).where(["created_at < ?", @post.created_at ]).order('created_at desc').first

    #相关文章 热门文章 最新发表
    @related_posts = SubjectPost.where(is_publish:true, subject_id:@subject.id).where.not(id:params[:post_id]).order('RANDOM()').limit(10)
    @hot_posts = SubjectPost.where(is_publish:true).where.not(id:params[:post_id]).order('view_sum desc,comment_sum desc').limit(10)
    @recent_posts = SubjectPost.where(is_publish:true).where.not(id:params[:post_id]).order('created_at desc').limit(10)

    #猜你喜欢
    @maybelike_posts = SubjectPost.where(is_publish:true, subject_id:@subject.id).where.not(id:params[:post_id]).where.not(cover_path:nil).order('RANDOM()').limit(3)

    #favorite状态
    @is_favorite = @current_uid && FavoritePost.where(uid:@current_uid, post_id:@post.id).first.present?

    #评论
    @post_comments = get_comment_list_with_avatars(params[:post_id])

    subject_sidebar @subject.id

    set_seo_meta(@post.title,@post.summary.truncate(120))
  end

  #创建post
  def new_post
    @subject = Subject.where(identify:params[:identify]).first
    return render '404' if @subject.nil?

    subject_sidebar @subject.id
  end

  #发布post
  def create_post
    subject = Subject.where(identify:params[:identify]).first
    return render text:'所属专题已经不存在' if subject.nil?

    cache_error = "请选择文章类型" if params[:content_type].blank?

    init_tags = params[:tags].to_s.strip.gsub('  ',' ')
    init_content_type = params[:content_type].to_i
    init_content = sanitize_content(params[:content])
    init_embed_summary = sanitize_embed_summary(init_content)
    init_is_publish = params[:is_publish].present?
    
    if init_content_type==SubjectPost::TYPE[:video] or init_content_type==SubjectPost::TYPE[:audio]
      if init_embed_summary.strip.empty?
        cache_error = "未检测到音频/视频模块"
      end
    end

    if params[:title].to_s.empty? or params[:content].to_s.empty?
      cache_error = "请输入标题和正文"
    else
      if init_tags.present?
        tags_arr = init_tags.split(' ')
        if tags_arr.length > 5 
          cache_error = "最多支持5个标签"
        else
          tags_arr = tags_arr.collect{ |tag| tag.strip }.uniq
          tags_arr.each do |tag|
            if tag.is_longer_than 7
              cache_error = "单个标签限7个字"
              break
            end
          end
          init_tags = tags_arr.join(' ')
        end
      end
    end

    post = SubjectPost.new
    post.title = params[:title]
    post.content = init_content
    post.summary = params[:summary]
    post.embed_summary = init_embed_summary
    post.content_type = init_content_type
    post.tags = init_tags
    post.is_publish = init_is_publish
    post.subject_id = subject.id
    post.subject_identify = subject.identify

    if cache_error
      post.is_publish = false
      post.save
      flash[:error] = cache_error
      return redirect_to "/subject_post/#{post.id}/edit"
    else
      post.created_at = Time.now
      post.save
      if post.is_publish
        publish_post_process(post,subject)
        flash[:succ] = "发布成功"
      else
        flash[:notice] = "保存成功，还未发布"
      end
      return redirect_to "/subject/#{params[:identify]}"
    end
  end

  #发布文章
  def publish_post_process(post,subject)
    if post.tags.present?
      subject_tags_create_sum = 0
      post.tags.split(' ').each do |tag|
        SubjectPostTags.create(tag:tag,subject_id:subject.id,post_id:post.id)
        subject_tag = SubjectTags.where(tag:tag,subject_id:subject.id).first
        if subject_tag
          subject_tag.post_sum = subject_tag.post_sum.to_i + 1
          subject_tag.save
        else
          SubjectTags.create(tag:tag,subject_id:subject.id,post_sum:1)
          subject_tags_create_sum += 1
        end
        subject.tag_sum = subject.tag_sum.to_i + subject_tags_create_sum
      end
    end
    subject.post_sum = subject.post_sum.to_i + 1
    subject.save
  end

  #下架文章
  def unpublish_post_process(post,subject)
    if post.tags.present?
      subject_tags_destroy_sum = 0
      post.tags.split(' ').each do |tag|
        SubjectPostTags.where(tag:tag,subject_id:subject.id,post_id:post.id).destroy
        subject_tag = SubjectTags.where(tag:tag,subject_id:subject.id).first
        if subject_tag
          origin_post_sum = subject_tag.post_sum.to_i
          if origin_post_sum > 1
            subject_tag.post_sum = origin_post_sum - 1
            subject_tag.save
          else
            SubjectTags.where(tag:tag,subject_id:subject.id).destroy
            subject_tags_destroy_sum += 1
          end
        end
        result_tag_sum = subject.tag_sum.to_i - subject_tags_destroy_sum
        subject.tag_sum = result_tag_sum>0 ? result_tag_sum : 0
      end
    end
    subject.post_sum = subject.post_sum.to_i - 1
    subject.save
  end


  #编辑post(标签不可以修改)
  def edit_post
    #params[:post_id]
    @post = SubjectPost.where(id:params[:post_id]).first
    return render '404' if @post.nil?

    @subject = Subject.where(identify:@post.subject_identify).first
    return render '404' if @subject.nil?

    subject_sidebar @subject.id
  end

  def update_post
    #params[:post_id]
    post = SubjectPost.where(id:params[:post_id]).first
    return render '404' if post.nil?

    subject = Subject.where(identify:post.subject_identify).first
    return render '404' if subject.nil?

    cache_error = "请选择文章类型" if params[:content_type].blank?

    init_content = sanitize_content(params[:content])
    init_embed_summary = sanitize_embed_summary(init_content)
    init_content_type = params[:content_type].to_i
    init_is_publish = params[:is_publish].present?
    if init_content_type==SubjectPost::TYPE[:video] or init_content_type==SubjectPost::TYPE[:audio]
      if init_embed_summary.strip.empty?
        cache_error = "未检测到音频/视频模块"
      end
    end

    if params[:title].blank?
      cache_error = "请输入标题和正文"
    end

    if cache_error
      flash[:error] = cache_error
      return redirect_to request.referer
    else

      origin_is_publish = post.is_publish

      post.title = params[:title]
      post.content = init_content
      post.summary = params[:summary]
      post.embed_summary = init_embed_summary
      post.content_type = init_content_type
      post.is_publish = init_is_publish
      if post.valid?
        post.save

        if post.is_publish != origin_is_publish
          if post.is_publish
            publish_post_process(post,subject)
          else
            unpublish_post_process(post,subject)
          end
        end

        flash[:succ] = "修改成功"
        return redirect_to "/subject/#{post.subject_identify}/#{post.id}"
      else
        flash[:error] = "修改失败"
        return redirect_to request.referer
      end
    end
  end

  #删除post
  def destroy_post
    #params[:post_id]
    return redirect_to request.referer,notice:'需要管理员权限' unless admin?
    @post = SubjectPost.where(id:params[:post_id]).first
    @post.destroy if @post
    flash[:succ] = '删除成功'
    redirect_to request.referer
  end

  def upload_post_cover_image

    post = SubjectPost.where(id:params[:post_id]).first
    post.cover_path = params[:Filedata]
    post.save

    return render json:{img_src:post.cover_path.big.url}
  end


  #ueditor 上传图片
  def upload_image
    return render json:{url:'error',srcUrl:params[:upfile]} if params[:upfile].to_s.strip.empty?
    uploader = SubjectPostUploader.new
    uploader.store!(params[:upfile])
    url = uploader.url
    return render json: {url:uploader.url,title:uploader.identifier,original:uploader.url,state:'SUCCESS'}
  end

  #ueditor 上传远程图片
  def get_remote_image
    return render json:{url:'error',srcUrl:params[:upfile]} if params[:upfile].to_s.strip.empty?
    ue_separate = ' ue_separate_ue '
    image_url_list = params[:upfile].split(ue_separate)
    return render json:{url:'error',srcUrl:params[:upfile]} if image_url_list.empty?
    result_list = []
    image_url_list.each do |url|
      uploader = SubjectPostUploader.new
      remote_file = CarrierWave::Uploader::Download::RemoteFile.new url
      uploader.store!(remote_file)
      result_list << uploader.url
    end

    url = result_list.join(ue_separate)

    return render json: {url:url,tip:'远程图片抓取成功',srcUrl:params[:upfile]}
  end

  #喜欢文章 ajax
  def add_favorite
    # params[:post_id]
    return render_400 unless signed_in?

    return render_412 "post_id" if params[:post_id].nil?

    post = SubjectPost.where(id:params[:post_id]).first
    return render json:{res:false,msg:'操作失败，相关内容已经不存在'} if post.nil?

    favor = FavoritePost.where(uid:@current_uid, post_id:post.id).first
    if favor.nil?
      FavoritePost.create(uid:@current_uid, nickname:@current_user.nickname, post_id:post.id, 
                          post_title:post.title, subject_id:post.subject_id, subject_title:post.subject_title, 
                          subject_identify: post.subject_identify, summary: post.summary,
                          content_type: post.content_type, embed_summary: post.embed_summary)
      favorite_sum = post.favorite_sum.to_i+1
      post.update_attributes(favorite_sum:favorite_sum)
      flag = 'add'
    else
      favorite_sum = post.favorite_sum.to_i
      flag = ''
    end

    render json:{res:true,msg:'',flag:flag,favorite_sum:favorite_sum}
  end

  #取消喜欢文章 ajax
  def remove_favorite
    # params[:post_id]
    return render_400 unless signed_in?

    return render_412 "post_id" if params[:post_id].nil?

    post = SubjectPost.where(id:params[:post_id]).first
    favor = FavoritePost.where(uid:@current_uid,post_id:params[:post_id]).first
    if favor
      favor.destroy
      if post
        oriCount = post.favorite_sum.to_i
        favorite_sum = oriCount > 1 ? oriCount-1 : 0
        post.update_attributes(favorite_sum: favorite_sum)
      else
        favorite_sum = 0
      end
      flag = 'reduce'
    else
      favorite_sum = post ? post.favorite_sum.to_i : 0
      flag = ''
    end

    render json:{res:true,msg:'',flag:flag,favorite_sum:favorite_sum}
  end

  #评论文章
  def add_comment
    # params[:post_id]
    return render_400 unless signed_in?

    init_content = sanitize_all(params[:content].to_s.strip)
    return render_412 "post_id,content" if params[:post_id].nil? or init_content.empty?

    post = SubjectPost.where(id:params[:post_id]).first
    return render json:{res:false,msg:'操作失败，相关内容已经不存在'} if post.nil?

    #避免连续两条相同的评论出现
    last_comment = SubjectPostComment.where(uid:@current_uid).order('id desc').first
    return render json:{res:false} if last_comment and last_comment.content==init_content

    #智能过滤机制  通过条件: 长度>=8 and (24小时对于当前文章回复数量<1 or 最后一条回复审核通过)
    # today_public_count = SubjectPostComment.where(uid:@current_uid,post_id:post.id).where("created_at > ?",1.day.ago).count
    # if init_content.is_longer_than(8) and (today_public_count < 1 or last_comment.is_public==1 ) 
    #   is_public = 0
    # else
    #   is_public = 2 
    # end

    is_public = 0

    comment = SubjectPostComment.create({post_id:post.id,post_title:post.title,subject_id:post.subject_id,
                                        subject_title:post.subject_title,subject_identify:post.subject_identify,
                                        content:init_content,uid:@current_uid,nickname:@current_user.nickname,
                                        is_verify:false,is_public:is_public})

    comment_sum = post.comment_sum.to_i+1
    post.update_attributes(comment_sum:comment_sum)

    render json:{res:true,msg:"评论成功",post_id:post.id,comment_id:comment.id,data:comment.to_json}
  end

  #删除评论
  def remove_comment
    # params[:post_id]
    return render_400 unless signed_in?

    return render_412 "comment_id" if params[:comment_id].nil?

    comment = SubjectPostComment.where(id:params[:comment_id]).first
    return render json:{res:'true'} if comment.nil?

    if comment.uid == @current_uid or admin?
      comment.destroy
      post = SubjectPost.where(id:params[:post_id]).first
      if post
        oriCount = post.comment_sum.to_i+1
        comment_sum = oriCount > 1 ? oriCount-1 : 0
        post.update_attributes(comment_sum: comment_sum)
      end
      return render json:{res:true,msg:'删除成功'}
    else
      return render json:{res:false,msg:"你没有权限删除别人的东西"}
    end
  end

  #评论列表 ajax
  def comment_list

    post_comments = get_comment_list_with_avatars(params[:post_id])

    htm = render_to_string(partial: 'post_comment_list', locals: {comments:post_comments})
    render json:{res:true,htm:htm}
  end

  #订阅专题
  def add_follow
    # params[:subject_id]
    return render_400 unless signed_in?

    return render_412 "subject_id" if params[:subject_id].nil?

    subject = Subject.where(id:params[:subject_id]).first
    return render json:{res:false,msg:'操作失败，该专题已经不存在'} if subject.nil?

    follow = FollowedSubject.where(uid:@current_uid, subject_id:subject.id).select('id').first
    if follow.nil?
      FollowedSubject.create(uid:@current_uid, subject_id:subject.id, 
                            subject_title:subject.title, subject_identify: subject.identify)
      flag = 'add'
    else
      flag = ''
    end

    render json:{res:true,msg:'订阅成功',flag:flag}
  end

  #取消订阅专辑
  def remove_follow
    # params[:subject_id]
    return render_400 unless signed_in?

    return render_412 "subject_id" if params[:subject_id].nil?

    follow = FollowedSubject.where(uid:@current_uid, subject_id:params[:subject_id]).select('id').first
    if follow
      follow.destroy
      flag = 'reduce'
    else
      flag = ''
    end

    render json:{res:true,msg:'',flag:flag}
  end

  #订阅用户列表
  def follower_list
    @subject = Subject.where(identify:params[:identify]).first
    return render '404' if @subject.nil?

    @follower_relations = FollowedSubject.where(subject_id:@subject.id).order('created_at desc').select('uid').page(params[:page]).per(40)

    follower_uids = @follower_relations.collect{|f| f.uid }
    @subject_followers = User.where(id:follower_uids).select('id,nickname,avatar_path,gender')

    subject_sidebar @subject.id
  end



private

  #侧边栏的数据
  def subject_sidebar(subject_id)

    #当前专题的一些数据
    #@subject_post_sum = SubjectPost.where(is_publish:true,subject_id:subject_id).count
    @subject_followers_sum = FollowedSubject.where(subject_id:subject_id).count

    #订阅的状态
    @is_follow = @current_uid && FollowedSubject.where(uid:@current_uid, subject_id:subject_id).select("id").first.present?

    #订阅该专题的人
    follower_uids = FollowedSubject.where(subject_id:subject_id).order('created_at desc').select('uid').limit(5).collect{|f| f.uid }
    @sidebar_followers = User.where(id:follower_uids).select('id,nickname,avatar_path,gender')

    #该专题下的标签 标签云
    subject_tags = SubjectTags.select('subject_id,tag,post_sum').where(subject_id:subject_id).order('post_sum desc').limit(45)
    tags_sum = subject_tags.length
    if tags_sum > 0
      rank_arr = []
      tags_sum.times do
        rank_arr << rand(13)
      end
      m = 12 - rank_arr.max
      rank_arr = rank_arr.collect{|n| n + m }.sort.reverse
      @subject_tags_cloud = [ subject_tags.to_a, rank_arr ].transpose.sample(tags_sum)
    else
      @subject_tags_cloud = []
    end

    #大家正在热议
    @public_comment_posts = SubjectPost.where(is_publish:true,subject_id:subject_id).where.not(comment_sum:nil).order('comment_sum desc,created_at desc').limit(6)

    #其它专题 也采用标签云样式
    other_subjects = Subject.select('id,post_sum,title,identify').where(["post_sum > ?",0]).where.not(id:subject_id).order('post_sum desc').limit(12)
    subjects_sum = other_subjects.length
    if subjects_sum > 0
      rank_arr = []
      subjects_sum.times do
        rank_arr << rand(13)
      end
      m = 12 - rank_arr.max
      rank_arr = rank_arr.collect{|n| n + m }.sort.reverse
      @other_subjects_cloud = [ other_subjects.to_a, rank_arr ].transpose.sample(tags_sum)
    else
      @other_subjects_cloud = []
    end
  end

  #获取带头像的评论列表
  def get_comment_list_with_avatars(post_id)
    post_comments = SubjectPostComment.where(post_id:post_id).where(public_condition).order('id desc').page(params[:page])
    comment_size = post_comments.length
    avatars,rescue_avatars = {},{}
    if comment_size > 0
      uids = post_comments.collect{|c| c.uid }.uniq
      User.where(id:uids).select('id,avatar_path,gender').each do |u|
        avatars[u.id] = u.avatar_path.normal.url
        rescue_avatars[u.id] = u.avatar_path.normal.default_url
      end
    end
    {list:post_comments,avatars:avatars,rescue_avatars:rescue_avatars}
  end

end
