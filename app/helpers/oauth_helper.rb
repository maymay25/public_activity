# -*- coding:utf-8 -*-
module OauthHelper

  require 'timeout'

  class WeiboAuth
    
    def authorize_url
      "https://api.weibo.com/oauth2/authorize?response_type=code&client_id=#{Settings.oauth2.weibo_key}&redirect_uri=#{Settings.oauth2.weibo_redirect_uri}"    
    end

    def callback(code)
      @uid = Timeout::timeout(20) do
        response = RestClient.post('https://api.weibo.com/oauth2/access_token', 
                                                   :client_id => Settings.oauth2.weibo_key, 
                                                   :client_secret => Settings.oauth2.weibo_secret,
                                                   :grant_type => 'authorization_code',
                                                   :code => code,
                                                   :redirect_uri => Settings.oauth2.weibo_redirect_uri)
        @access_token = JSON.parse(response)['access_token']
        JSON.parse(RestClient.get("https://api.weibo.com/2/account/get_uid.json?access_token=#{@access_token}"))['uid']
      end
      raise "验证失败" unless @access_token
      raise "获取微博用户ID失败" unless @uid
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    def get_user_info
      user_info = Timeout::timeout(20) do
        JSON.parse(RestClient.get("https://api.weibo.com/2/users/show.json?uid=#{@uid}&access_token=#{@access_token}"))
      end
      unless user_info["name"]
        STDERR.puts "Weibo获取用户信息错误:" + user_info.inspect
        raise "获取用户信息时发生错误，请稍后重试"
      end
      user_info
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    #发送微博
    def self.update_status(content,access_token)
      response = Timeout::timeout(20) do
        RestClient.post('https://api.weibo.com/2/statuses/update.json',
                                  {:status => content,:access_token => access_token})
      end
      response
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    #发送带图片的微博
    def self.upload_status(content,access_token)
      response = Timeout::timeout(20) do
        pic = File.open("#{Rails.root}/public/assets/img/share_img.jpg","rb")
        RestClient.post('https://api.weibo.com/2/statuses/upload.json',
                                  {:pic => pic,:status => content,:access_token => access_token})
      end
      response
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

  end

  class RenrenAuth
    
    def authorize_url
      "https://graph.renren.com/oauth/authorize?client_id=#{Settings.oauth2.renren_key}&redirect_uri=#{Settings.oauth2.renren_redirect_uri}&response_type=code"   
    end

    def callback(code)
      Timeout::timeout(20) do
        response = RestClient.post('https://graph.renren.com/oauth/token', 
                                                   :client_id => Settings.oauth2.renren_key,
                                                   :client_secret => Settings.oauth2.renren_secret,
                                                   :grant_type => 'authorization_code',
                                                   :code => code,
                                                   :redirect_uri => Settings.oauth2.renren_redirect_uri)
        info = JSON.parse(response)
        @access_token = info['access_token']
        @user = info['user']
      end
      raise "验证失败" unless @access_token
      raise "获取人人网用户信息失败" unless @user
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    def get_user_info
      @user
    end

    #发送新鲜事
    def self.put_feed(content,access_token)
      response = Timeout::timeout(20) do
        RestClient.post('https://api.renren.com/v2/feed/put',
                                  {:message => content,
                                   :access_token => access_token,
                                   :title => '安慰小屋 - 随心社区',
                                   :targetUrl => 'http://www.suixin365.com',
                                   :imageUrl => 'http://www.suixin365.com/assets/img/share_img.jpg',
                                   :description => '安慰小屋是一个可以找寻安慰的地方。来这里倾述你的烦恼吧 http://www.suixin365.com'})
      end
      response
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end
  end

  class KaixinAuth
    
    def authorize_url
      "http://api.kaixin001.com/oauth2/authorize?client_id=#{Settings.oauth2.kaixin_key}&redirect_uri=#{Settings.oauth2.kaixin_redirect_uri}&response_type=code"   
    end

    def callback(code)
      Timeout::timeout(20) do
        response = RestClient.post('https://api.kaixin001.com/oauth2/access_token', 
                                                   :client_id => Settings.oauth2.kaixin_key,
                                                   :client_secret => Settings.oauth2.kaixin_secret,
                                                   :grant_type => 'authorization_code',
                                                   :code => code,
                                                   :redirect_uri => Settings.oauth2.kaixin_redirect_uri)
        @access_token = JSON.parse(response)['access_token']
        @user = JSON.parse(RestClient.get("https://api.kaixin001.com/users/me.json?access_token=#{@access_token}"))
      end
      raise "验证失败" unless @access_token
      raise "获取开心网用户信息失败" unless @user
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    def get_user_info
      @user
    end

  end

  class QQAuth
    
    def authorize_url
      "https://graph.qq.com/oauth2.0/authorize?client_id=#{Settings.oauth2.qq_key}&redirect_uri=#{Settings.oauth2.qq_redirect_uri}&response_type=code"   
    end

    def callback(code)
      Timeout::timeout(20) do
        response = RestClient.post('https://graph.qq.com/oauth2.0/token', 
                                                   :client_id => Settings.oauth2.qq_key,
                                                   :client_secret => Settings.oauth2.qq_secret,
                                                   :grant_type => 'authorization_code',
                                                   :code => code,
                                                   :redirect_uri => Settings.oauth2.qq_redirect_uri)
        info = {}
        response.split("&").each do |r1|
          x,y = r1.split("=")
          info[x] = y
        end
        @access_token = info['access_token']
        open_id_info = RestClient.get("https://graph.qq.com/oauth2.0/me?access_token=#{@access_token}")
        @open_id = open_id_info[45,32]
      end
      raise "验证失败" unless @access_token
      raise "获取QQ OPEN_ID失败" unless @open_id
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    def get_user_info
      user_info = Timeout::timeout(20) do
        JSON.parse(RestClient.get("https://graph.qq.com/user/get_user_info?access_token=#{@access_token}&oauth_consumer_key=#{Settings.oauth2.qq_key}&openid=#{@open_id}"))
      end
      user_info["uid"] = @open_id
      unless user_info["nickname"] and user_info["uid"]
        STDERR.puts "QQ获取用户信息错误:" + user_info.inspect
        raise "获取用户信息时发生错误，请稍后重试"
      end
      user_info
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

  end

  #腾讯微博站内应用 基于openid&openkey
  class QQWeiboAuth
    include ApplicationHelper

    def get_user_info(openid,openkey)
      response = Timeout::timeout(20) do

        query = {
          clientip: request.remote_ip,
          format:'json',
          reqtime:Time.now.to_i,
          appid:Settings.app.qq_app_id,
          openid:openid,
          openkey:openkey,
          wbversion:1
        }

        query[:sig] = generate_sig('GET','/user/info',query)

        query_string = query.collect{|key,value|"#{key}=#{value}"}.join("&")

        RestClient.get( "http://open.t.qq.com/api/user/info?" + query_string )

      end

      user_info = JSON.parse(response)['data']

      unless user_info["nick"] and user_info["openid"]
        STDERR.puts "QQ获取用户信息错误:" + user_info.inspect
        raise "获取用户信息时发生错误，请稍后重试"
      end
      user_info
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    #发送微博
    def add_t(content,openid,openkey,clientip)
      return if openid.nil? or openkey.nil?
      response = Timeout::timeout(20) do
        query = {
          clientip: clientip,
          content:content,
          format:'json',
          reqtime:Time.now.to_i,
          appid:Settings.app.qq_app_id,
          openid:openid,
          openkey:openkey,
          wbversion:1
        }
        query[:sig] = generate_sig('POST','/t/add',query)
        RestClient.post('http://open.t.qq.com/api/t/add', query)
      end
      response
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    #发送带图片的微博
    def add_pic_t(content,openid,openkey,clientip)
      return if openid.nil? or openkey.nil?
      response = Timeout::timeout(20) do
        query = {
          clientip: clientip,
          content:content,
          format:'json',
          reqtime:Time.now.to_i,
          appid:Settings.app.qq_app_id,
          openid:openid,
          openkey:openkey,
          wbversion:1
        }
        query[:sig] = generate_sig('POST','/t/add_pic',query)
        query[:pic] = File.open("#{Rails.root}/public/assets/img/share_img.jpg","rb")
        RestClient.post('http://open.t.qq.com/api/t/add_pic',query)
      end
      response
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end 

    #生成签名
    def generate_sig(method,uri,query)
      str = ""
      str += method
      str += CGI.unescape(uri)
      str += query.sort.collect{|key,value|"#{key}=#{value}"}.join("&")
      str += Settings.app.qq_app_secret
      return encode64_url Digest::SHA1.hexdigest(str)
    end

  end


  class DoubanAuth
    
    def authorize_url
      "https://www.douban.com/service/auth2/auth?client_id=#{Settings.oauth2.douban_key}&redirect_uri=#{Settings.oauth2.douban_redirect_uri}&response_type=code"   
    end

    def callback(code)
      Timeout::timeout(20) do
        response = RestClient.post('https://www.douban.com/service/auth2/token', 
                                                   :client_id => Settings.oauth2.douban_key,
                                                   :client_secret => Settings.oauth2.douban_secret,
                                                   :grant_type => 'authorization_code',
                                                   :code => code,
                                                   :redirect_uri => Settings.oauth2.douban_redirect_uri)
        info = JSON.parse(response)
        @access_token = info['access_token']
        @uid = info['douban_user_id']
      end
      raise "验证失败" unless @access_token
      raise "获取QQ OPEN_ID失败" unless @uid
    rescue Timeout::Error
      raise "访问超时，请稍后重试"
    end

    def get_user_info
      {uid:@uid}
    end

  end


end
