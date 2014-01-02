require(['jquery','underscore','page'], function( $, _, Page ){

  function switch_join_group(ele){
    var $ele = $(ele),
        is_follow = $ele.hasClass('already'),
        group_id = $ele.data('group-id');

    if(!group_id){
      return false;
    }

    if(is_follow){
      // 退出小组
      $.ajax({
          url:'/group/quit_group',
          type:"post",
          dataType:"json",
          data:{
              group_id: group_id
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                flag = json.flag;
            if(res){
              $ele.removeClass('already');
              if(msg&&flag=="quit"){
                Page.showQZMsg(msg,'succ');
              }
            }else{
              if(msg){
                Page.showTopNotice(msg,'error');
              }
            }
          }
      });
    }else{
      // 加入小组
      $.ajax({
          url:'/group/join_group',
          type:"post",
          dataType:"json",
          data:{
              group_id: group_id
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                flag = json.flag;
            if(res){
              $ele.addClass('already');
              if(msg && flag=="join"){
                Page.showQZMsg(msg,'succ');
              }
            }else{
              if(msg){
                Page.showTopNotice(msg,'error');
              }
            }
          }
      });
    }
  }

  window.switch_join_group = switch_join_group;
})