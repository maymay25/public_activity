# -*- coding:utf-8 -*-
class LibController < ApplicationController
  layout:false


  #2013-08-30
  #jefyteam JEFY工作室 微信公众平台
  def weixin
    if request.post?
      #post 用户指令
      return render nothing:true if params[:xml].nil?
      request = params[:xml]
      msgType,server_name,user_name = request[:MsgType],request[:ToUserName],request[:FromUserName]

      if msgType == "text"
        content = request[:Content].downcase
        if content == "我爱你"
          msg = "我也爱你"
          return render text: _weixin_text(server_name,user_name,msg)
        elsif content == "你爱谁"
          msg = "我爱朱小梅"
          return render text: _weixin_text(server_name,user_name,msg)
        elsif content == "谁是你老婆"
          msg = "朱小梅"
          return render text: _weixin_text(server_name,user_name,msg)
        elsif content == "你老婆漂亮吗"
          msg = "非常漂亮，大美人！"
          return render text: _weixin_text(server_name,user_name,msg)
        elsif content == "我老公是大帅哥"
          music = {title:"【爱情那些事】爱情婚姻启示录之--我们为什么结婚--绒绒",intro:"已经很久很久都没有听到有一个人说，他要结婚是因为很爱很爱一个人，因为想和另一个人永远的在一起。",play_path: "http://fdfs.xmcdn.com/group3/M02/19/27/wKgDslITEuTRf2hKApls0AgndqM076.mp3"}
          return render text: _weixin_music(server_name,user_name,music)
        else
          return render nothing:true
        end
      elsif msgType == "event"
        event = request[:Event]
        if event=="subscribe"
          title = "我是许其勇，你好"
          description = "我爱我的老婆，朱小梅，么么"
          list = [{title:title,description:description,pic_url:"http://tp3.sinaimg.cn/1781109774/180/22852678814/1",url:"javascript:;"}]
          return render text: _weixin_list(server_name,user_name,list)
        elsif event=="unsubscribe"
          # msg = "处理取消订阅事件"
          # return render text: _weixin_text(server_name,user_name,msg)
          return render nothing:true
        else
          return render nothing:true
        end
      else
        return render nothing:true
      end
    else
      #微信服务器将发送GET请求 确认接入
      #return render text:params[:echostr]
      if params[:signature] and params[:timestamp] and params[:nonce] and params[:echostr]
        token = "jeffrey" #设置的令牌
        string = [token,params[:nonce],params[:timestamp]].sort.join("")
        digested_string = Digest::SHA1.hexdigest string
        if digested_string == params[:signature]
          return render text:params[:echostr]
        else
          return render text:'验证失败'
        end
      end
      return render nothing:true
    end

  end


  # 文字信息 拼凑微信需要的xml格式
  def _weixin_text(server_name,user_name,msg)
    xml = "<xml>\n"
    xml << "<ToUserName>"+user_name+"</ToUserName>\n"
    xml << "<FromUserName>"+server_name+"</FromUserName>\n"
    xml << "<CreateTime>#{Time.now.to_i}</CreateTime>\n"
    xml << "<MsgType>text</MsgType>\n"
    xml << "<Content>#{msg}</Content>\n"
    xml << "<FuncFlag>1</FuncFlag>\n"
    xml << "</xml>"
    return xml
  end

  # 音乐信息 拼凑微信需要的xml格式
  def _weixin_music(server_name,user_name,music)
    xml = "<xml>\n"
    xml << "<ToUserName>"+user_name+"</ToUserName>\n"
    xml << "<FromUserName>"+server_name+"</FromUserName>\n"
    xml << "<CreateTime>#{Time.now.to_i}</CreateTime>\n"
    xml << "<MsgType>music</MsgType>\n"
    xml << "<Music>\n"
    xml << "<Title>#{music[:title]}</Title>\n"
    xml << "<Description>#{music[:intro]}</Description>\n"
    xml << "<MusicUrl>#{music[:play_path]}</MusicUrl>\n"
    xml << "<HQMusicUrl>#{music[:play_path]}</HQMusicUrl>\n"
    xml << "</Music>\n"
    xml << "</xml>"
    return xml
  end

  # 图文列表信息 拼凑微信需要的xml格式
  def _weixin_list(server_name,user_name,list)
    return "" if list.count == 0
    count = list.count
    xml = "<xml>\n"
    xml << "<ToUserName>"+user_name+"</ToUserName>\n"
    xml << "<FromUserName>"+server_name+"</FromUserName>\n"
    xml << "<CreateTime>#{Time.now.to_i}</CreateTime>\n"
    xml << "<MsgType>news</MsgType>\n"
    xml << "<ArticleCount>#{count}</ArticleCount>\n"
    xml << "<Articles>\n"
    list.each do |item|
      xml << "<item>\n"
      xml << "<Title>#{item[:title]}</Title> \n"
      xml << "<Description>#{item[:description]}</Description>\n"
      xml << "<PicUrl>#{item[:pic_url]}</PicUrl>\n"
      xml << "<Url>#{item[:url]}</Url>\n"
      xml << "</item>\n"
    end
    xml << "</Articles>\n"
    xml << "</xml>"
    return xml
  end


  # 2013-08-30
  # 测试ip地址，以及用户的位置
  def ip

    ip = request.headers['X-Real-IP'] || request.remote_ip
    json = IpTable.get_location(ip)

    json[:ip] = ip
    json[:user_agent] = request.user_agent

    render json:json
  end


  # 2013-03-29
  def rspec

    variable = 'hello!'

    @variable = 'yeah!'

    render :text=>"rspec #{Time.now}"

  end


  # 2013-03-25
  def sidekiq
    HardWorker.perform_async('bob', 5)
    render :text=>'sidekiq'
  end

  # 2013-03-17
  def redis_objects
      @tb_user = User.find("jeffrey6052")
      # p @tb_user.redis_cache.value
      # @tb_user = User.find("carino0208")
  end

  # 2013-03-16
  def settings

    render :json=>Settings.to_json
  end

  # 2013-03-16
  def settings_fresh
    Settings.reload!
    redirect_to "/lib/settings"
  end

  # 2013-10-13  阿里妈妈 充值服务
  def chongzhi

  end

  #测试微信二维码扫描转码
  def tencent

    render layout:false
  end

end
