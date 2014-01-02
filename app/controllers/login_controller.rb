# -*- coding:utf-8 -*-
class LoginController < ApplicationController
  #before_filter :check_signed_in,:except=>['signout']
  include OauthHelper
  layout 'comfortplace'

  skip_before_action :verify_authenticity_token, only: [:weibo_callback, :renren_callback, :kaixin_callback, :qq_callback, :douban_callback]

  # 登陆
  def signin
    if request.post?
      user = User.authenticate(params[:account],params[:password])
      if user.nil?
        flash.now[:alert] = '账号或者密码不正确'
        return render 'login/signin' 
      end
      sign_in_count = user.sign_in_count.to_i + 1
      user_attrs = {last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip,sign_in_count:sign_in_count}
      user.update_attributes(user_attrs)
      self.current_user = user
      set_sign_in_cookie(user.id)
      return redirect_back_or_default '/'
    end
    set_seo_meta('登陆')
  end

  # 注册
  def signup
    if request.post? and params[:user]
      if error = User.signup_error(params[:user])
        flash.now[:alert] = error
        flash.now[:time] = 0
        return render 'login/signup'
      end
      user = User.new(params[:user])

      if params[:avatar_path]
        user.avatar_path = params[:avatar_path]
      end

      if user.valid?
          user.save # && User.perform_async(:send_sign_up_mail, user.id)
          self.current_user = user
          user.update_attributes(last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
          redirect_to '/'
      else
        flash.now[:alert] = user.errors.inspect
        flash.now[:time] = 0
        render 'login/signup'
      end
    end
    set_seo_meta('注册')
  end

  def signout
    clear_login_state
    clear_sign_in_cookie

    if request.xhr?
      render json:{res:true,msg:'退出成功'}
    else
      # flash[:notice] = '退出成功'
      if request.referer
        redirect_to request.referer
      else
        redirect_to signin_path
      end
    end
  end

  #前端获取当前登录用户的信息
  def accountInfo
    return render json:{res:true} unless signed_in?
    
    render json:{res:true,nickname:@current_user.nickname,uid:@current_uid}

  end


  def weibo_login
    redirect_to WeiboAuth.new.authorize_url
  end

  def weibo_callback

    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} if params[:error]

    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} unless params[:code]

    auth = WeiboAuth.new
    auth.callback(params[:code])
    user_info = auth.get_user_info

    weibo_uid = user_info["id"]
    weibo_name = user_info["name"]
    raise "用户信息错误" unless weibo_uid and weibo_name

    user = User.find_come_user(weibo_uid,User::COME_FROM[:weibo])
    if user.nil?
      user = User.create(come_id:weibo_uid,come_from:User::COME_FROM[:weibo],nickname:weibo_name,
                        last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
    else
      attrs = {last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip}
      attrs[:nickname] = weibo_name if user.nickname.to_s=="" or user.nickname[0,5]=="weibo"
      user.update_attributes(attrs)
    end
    self.current_user = user
    set_sign_in_cookie(user.id)

    puts user.id

    render partial:'oauth2_callback',locals:{success:true,txt:"登陆成功",style:'succ'}
  rescue
    render partial:'oauth2_callback',locals:{success:false,txt:"抱歉,登录失败,请稍后重试",style:'error'}
  end

  def renren_login
    redirect_to RenrenAuth.new.authorize_url
  end

  def renren_callback

    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} if params[:error]
    
    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} unless params[:code]
    
    auth = RenrenAuth.new
    auth.callback(params[:code])
    user_info = auth.get_user_info
    renren_uid = user_info["id"]
    renren_name = user_info["name"]
    raise "用户信息错误" unless renren_uid and renren_name

    user = User.find_come_user(renren_uid,User::COME_FROM[:renren])
    if user.nil?
      user = User.create(come_id:renren_uid,come_from:User::COME_FROM[:renren],nickname:renren_name,
                        last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
    else
      attrs = {last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip}
      attrs[:nickname] = renren_name if user.nickname.to_s=="" or user.nickname[0,6]=="renren"
      user.update_attributes(attrs)
    end
    self.current_user = user
    set_sign_in_cookie(user.id)
    render partial:'oauth2_callback',locals:{success:true,txt:"登陆成功",style:'succ'}
  rescue
    render partial:'oauth2_callback',locals:{success:false,txt:"抱歉,登录失败,请稍后重试",style:'error'}
  end


  def kaixin_login
    redirect_to KaixinAuth.new.authorize_url
  end

  def kaixin_callback

    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} if params[:error]
    
    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} unless params[:code]
    
    auth = KaixinAuth.new
    auth.callback(params[:code])
    user_info = auth.get_user_info
    kaixin_uid = user_info["uid"]
    kaixin_name = user_info["name"]
    raise "用户信息错误" unless kaixin_uid and kaixin_name

    user = User.find_come_user(kaixin_uid,User::COME_FROM[:kaixin])
    if user.nil?
      user = User.create(come_id:kaixin_uid,come_from:User::COME_FROM[:kaixin],nickname:kaixin_name,
                        last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
    else
      attrs = {last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip}
      attrs[:nickname] = kaixin_name if user.nickname.to_s=="" or user.nickname[0,6]=="kaixin"
      user.update_attributes(attrs)
    end
    self.current_user = user
    set_sign_in_cookie(user.id)
    render partial:'oauth2_callback',locals:{success:true,txt:"登陆成功",style:'succ'}
  rescue
    render partial:'oauth2_callback',locals:{success:false,txt:"抱歉,登录失败,请稍后重试",style:'error'}
  end


  def qq_login
    redirect_to QQAuth.new.authorize_url
  end

  def qq_callback

    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} if params[:error]
    
    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} unless params[:code]
    
    auth = QQAuth.new
    auth.callback(params[:code])
    user_info = auth.get_user_info

    qq_uid = user_info["uid"]
    qq_name = user_info["nickname"]
    raise "用户信息错误" unless qq_uid and qq_name

    user = User.find_come_user(qq_uid,User::COME_FROM[:qq])
    if user.nil?
      user = User.create(come_id:qq_uid,come_from:User::COME_FROM[:qq],nickname:qq_name,
                        last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
    else
      attrs = {last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip}
      attrs[:nickname] = qq_name if user.nickname.to_s=="" or user.nickname[0,2]=="qq"
      user.update_attributes(attrs)
    end
    self.current_user = user
    set_sign_in_cookie(user.id)
    render partial:'oauth2_callback',locals:{success:true,txt:"登陆成功",style:'succ'}
  rescue
    render partial:'oauth2_callback',locals:{success:false,txt:"抱歉,登录失败,请稍后重试",style:'error'}
  end


  def douban_login
    redirect_to DoubanAuth.new.authorize_url
  end

  def douban_callback

    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} if params[:error]
    
    return render partial:'oauth2_callback',locals:{success:false,txt:"登录失败",style:'error'} unless params[:code]
    
    auth = DoubanAuth.new
    auth.callback(params[:code])
    user_info = auth.get_user_info
    douban_uid = user_info[:uid]

    raise "用户信息错误" unless douban_uid

    user = User.find_come_user(douban_uid,User::COME_FROM[:douban])
    if user.nil?
      user = User.create(come_id:douban_uid,come_from:User::COME_FROM[:douban],nickname:"douban#{douban_uid}",
                        last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
    else
      attrs = {last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip}
      user.update_attributes(attrs)
    end
    self.current_user = user
    set_sign_in_cookie(user.id)
    render partial:'oauth2_callback',locals:{success:true,txt:"登陆成功",style:'succ'}
  rescue
    render partial:'oauth2_callback',locals:{success:false,txt:"抱歉,登录失败,请稍后重试",style:'error'}
  end

  private

  def check_signed_in
    return redirect_to :root if signed_in?
  end

end
