# -*- coding:utf-8 -*-
module ApplicationHelper

  #未登录
  def render_400
      render text: '未登录', status: 400
  end

  #没有权限
  def render_401
    render text: '你没有权限进行该操作', status: 401
  end

  #资源不存在
  def render_404(msg=nil)
    render text: msg,status:404
  end

  #操作失败
  def render_500(msg=nil)
    render text: msg,status:500
  end

  #请求有误
  def render_412(msg=nil)
    text = "参数错误。"
    text += " #{msg}" if msg
    render text: text, status: 412
  end

  #静态文件url
  def static_url(file,noVersion=false)
    url = "#{Settings.static_root}#{file}"
    url += "?v=#{APP_VERSION}" unless noVersion
    return url
  end

  #获取文件url
  def file_url(file_path)
    return file_path if file_path.nil? or file_path.empty?
    file_path.match(/^http/) ? file_path : File.join(Settings.oss_root, file_path)
  end

  #时间转化 2013-06-03 05:33 ==> 5分钟前
  def feed_time(time)
    time = time.to_datetime if time.class==String
    fsec = Time.new - time
    fmin = fsec / 60
    fhour = fmin / 60
    fday = fhour / 24
    fmon = fday / 30
    fyear = fmon / 12

    sec = fsec.to_i
    min = fmin.to_i
    hour = fhour.to_i
    day = fday.to_i
    mon = fmon.to_i
    year = fyear.to_i

    year > 0 ? "#{year}年前" : (mon > 0 ? "#{mon}月前" : (day > 0 ? "#{day}天前" : (hour > 0 ? "#{hour}小时前" : (min > 5 ? "#{min}分钟前" : "刚刚"))))
  end

  #是否显示条件 审核通过的或者是自己发布的 (无人审核时设为nil)
  def public_condition
    @current_uid ? ["is_public != 2 or uid = ?", @current_uid] : "is_public != 2"
  end

  #是否发布条件 管理员没有限制
  def publish_condition
    admin? ? nil : {is_publish:true}
  end

  #检测IE6
  def ie6?
      @is_ie6 ||= (request.user_agent && request.user_agent.match(/(?i)msie [1-7]/)) ? 1 : 0
      @is_ie6 > 0
  end

  def ie8?
      return true if ie6?
      @is_ie8 ||= (request.user_agent && request.user_agent.match(/(?i)msie 8/)) ? 1 : 0
      @is_ie8 > 0
  end

  #检测是否为管理员
  def admin?
    @cache_is_admin ||= (
      if @current_uid
        config_admin_ids = [1]
        is_admin = config_admin_ids.include? @current_uid
        is_admin ? 1 : 0
      else
        0
      end )
    @cache_is_admin == 1
  end

  def trans_from(from)
    return {nil=>'随心社区',0=>'随心社区',1=>'新浪微博',2=>'人人网',3=>'开心网',4=>'腾讯QQ',5=>'豆瓣网'}[from]
  end

  def user_mark(user,me=nil)
    return me||"我" if user.id==@current_uid
    case user.gender
    when User::GENDER[:male]
      return "他"
    when User::GENDER[:female]
      return "她"
    else
      return "Ta"
    end
  end

  def encode64_url(data)
    Base64.encode64(data).tr('+/=', '-_ ').strip.delete("\n")
  end

  # Decodes a "base64url" encoded string to its original representation.
  # See <tt>Encoding#encode64_url</tt> for more information.
  def decode64_url(str)
    str = case str.length % 4
      when 2 then str + '=='
      when 3 then str + '='
      else
        str
    end
    Base64.decode64(str.tr('-_', '+/'))
  end
  
  def url_encode(s)
    s.to_s.gsub(/[^a-zA-Z0-9_\-.]/n){ sprintf("%%%02X", $&.unpack("C")[0]) }  
  end

end
