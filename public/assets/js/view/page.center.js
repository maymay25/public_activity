require(['jquery','underscore','page'], function( $, _, Page ){

  function switch_follow_user(ele){
    var $ele = $(ele),
        is_follow = $ele.hasClass('already'),
        uid = $ele.data('uid');

    if(!uid){
      return false;
    }

    if(is_follow){
      // 取消关注用户
      $.ajax({
          url:'/user/remove_follow',
          type:"post",
          dataType:"json",
          data:{
              uid: uid
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                flag = json.flag;
            if(res){
              $ele.removeClass('already');
              if(msg&&flag=="reduce"){
                Page.showQZMsg(msg,'succ');
              }
            }else{
              if(msg){
                Page.showQZMsg(msg,'error');
              }
            }
          }
      });
    }else{
      // 关注用户
      $.ajax({
          url:'/user/add_follow',
          type:"post",
          dataType:"json",
          data:{
              uid: uid
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                flag = json.flag;
            if(res){
              $ele.addClass('already');
              if(msg && flag=="add"){
                Page.showQZMsg(msg,'succ');
              }
            }else{
              if(msg){
                Page.showQZMsg(msg,'error');
              }
            }
          }
      });
    }
  };

  function chatTo(ele,options,callback){
    if(options){
      var uid = options.uid,
          content = options.content;
      post_user_chat(uid,content,callback);
    }else{
      var $ele = $(ele),
          uid = $ele.data('uid'),
          nickname = $ele.data('nickname'),
          content = content;
      if(!uid){
        return false;
      }
      Page.showChatBox({uid:uid,nickname:nickname},function(content){
        post_user_chat(uid,content,callback);
      })
    }
  };

  // 发送私信
  function post_user_chat(uid,content,callback){
    $.ajax({
        url:'/user/chat',
        type:"post",
        dataType:"json",
        data:{
            uid: uid,
            content: content
        },
        success:function(json){
          var res = json.res,
              msg = json.msg;
          close_template_box($('.chatBox'));
          if(res){
            window.cache_chatBox_content = null;
            if(callback){callback();}
            if(msg){
              Page.showQZMsg(msg,'succ');
            }
          }else{
            if(msg){
              Page.showQZMsg(msg,'error');
            }
          }
        }
    });
  };


  window.switch_follow_user = switch_follow_user;
  window.chatTo = chatTo;

})