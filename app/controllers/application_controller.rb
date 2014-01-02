# -*- coding:utf-8 -*-
class ApplicationController < ActionController::Base
    protect_from_forgery
    include ApplicationHelper

    helper_method :current_user, :signed_in?

    before_filter :set_current_info,:p3p_header

    #p3p header
    def p3p_header
        response.headers['P3P'] = "CP=CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"  
    end

    #全站filter 获取当前登录用户信息
    def set_current_info
        login_from_session || login_from_cookie

        if @current_user
            @current_uid = @current_user.id
        else
            @current_uid = nil
        end
        
    end

    #检测是否登录
    def signed_in?
        @current_user.present?
    end

    def require_login
        unless signed_in?
          clear_login_state
          flash[:alert] = '你尚未登陆，请登陆后继续操作'
          redirect_to_login
        end
    end

    def require_admin
        if !signed_in? or !admin?
            flash[:alert] = '需要管理员权限'
            redirect_to '/'
        end
    end

    def redirect_to_login
        session[:return_to] = request.fullpath
        redirect_to signin_path
        return
    end

    def redirect_back_or_default(default)
        if session[:return_to]
            return_to = session[:return_to]
        else
            return_to = default
        end
        session[:return_to] = nil
        redirect_to(return_to)
    end

    # Store the given user username in the session.
    def current_user=(new_user)
        if new_user
            session[:uid] = new_user.id
            @current_user = new_user
            @current_uid = new_user.id
        else
            session[:uid] = nil
            @current_user = nil
            @current_uid = nil
        end
    end

    def login_from_session
        self.current_user = User.find_cache(session[:uid]) if session[:uid] 
    end

    def login_from_cookie
        if session[:uid].blank? && cookies.signed[:remember_me].present?

            uid = cookies.signed[:remember_me]
            user = User.find_cache(uid)
            if user.present?
                self.current_user = user
            else
                clear_sign_in_cookie
                clear_login_state
            end
        end
    end

    def set_sign_in_cookie(uid)
        cookies.signed[:remember_me] = {
          :value => uid.to_s,
          :expires => 1.week.from_now,
          :path=>'/'
        }
    end

    def clear_sign_in_cookie
        cookies.delete(:remember_me)
    end

    def clear_login_state
        session[:uid] = nil
        session.clear
        @current_user = nil
    end

    def set_seo_meta(title = nil, meta_description = nil, meta_keywords = nil)
        default_description = "随心社区,是一个自由自在的网络社区。"
        default_keywords = "随心社区,随心365,网络社区,社区"
        @page_title = "#{title} - 随心社区" if title.present?
        @page_description = meta_description || default_description    
        @page_keywords = meta_keywords || default_keywords
    end



end
