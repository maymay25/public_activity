require(['jquery','underscore','page'], function( $, _, Page ){

  function add_new_comment(ele){
    var post_id = app_config['post_id'],
        $text_area = $('#comment_content'),
        content = $text_area.val();

    if(!post_id){
      Page.showTopNotice('评论失败，请稍候重试','error');
      return false;
    }

    content = content && $.trim(content);
    if(!content){
      Page.shine($text_area);
      $text_area.val('').focus();
      return false;
    }

    $.ajax({
        url:'/subject_post/add_comment',
        type:"post",
        dataType:"json",
        data:{
            post_id: post_id,
            content: content
        },
        success:function(json){
          var res = json.res,
              msg = json.msg,
              comment = json.comment;
          if(res){
            if(msg){
              Page.showQZMsg(msg,'succ');
              $text_area.val('');
            }
            $.ajax({
                url:'/subject_post/comment_list',
                type:"get",
                dataType:"json",
                data:{
                    post_id: post_id,
                    page: 1
                },
                beforeSend:function(){
                },
                success:function(data){
                  $('#commentlist').html(data.htm);
                }
            });
          }else{
            if(msg){
              Page.showTopNotice(msg,'error');
            }
          }
        },
        error:function(info){
          if(info.status==400){
            Page.todo_event.create({'dom':$(ele),'event':'click'});
          }
          Page.default_ajax_error_callback(info);
        }
    });
  }

  function switch_favorite(ele){
    var $ele = $(ele),
        is_favorite = $ele.hasClass('already'),
        post_id = $ele.data('post-id');

    if(!post_id){
      return false;
    }

    if(is_favorite){
      // 取消喜欢
      $.ajax({
          url:'/subject_post/remove_favorite',
          type:"post",
          dataType:"json",
          data:{
              post_id: post_id
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                sum = json.favorite_sum;
            if(res){
              $ele.removeClass('already');
              $sum_ele = $ele.children('.num');
              if(sum>0){
                $sum_ele.attr('title',''+sum+'人喜欢').html('+'+sum);
              }else{
                $sum_ele.attr('title','').html('');
              }
              if(msg){
                Page.showTopNotice(msg,'succ');
              }
            }else{
              if(msg){
                Page.showTopNotice(msg,'error');
              }
            }
          }
      });
    }else{
      // 添加喜欢
      $.ajax({
          url:'/subject_post/add_favorite',
          type:"post",
          dataType:"json",
          data:{
              post_id: post_id
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                sum = json.favorite_sum;
            if(res){
              $ele.addClass('already');
              $sum_ele = $ele.children('.num');
              if(sum>0){
                $sum_ele.attr('title',''+sum+'人喜欢').html('+'+sum);
              }else{
                $sum_ele.attr('title','').html('');
              }
              if(msg){
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

  function load_comments(ele){
    var $ele = $(ele),
        page = $ele.data('page'),
        post_id = app_config['post_id'];

    if(!post_id || !page){
      return false
    }

    $.ajax({
        url:'/subject_post/comment_list',
        type:"get",
        dataType:"json",
        data:{
            post_id: post_id,
            page: page
        },
        success:function(data){
          $('#commentlist').html(data.htm);
          window.location.href = '#comments';
        }
    });

  }

  function switch_follow_subject(ele){
    var $ele = $(ele),
        is_follow = $ele.hasClass('already'),
        subject_id = $ele.data('subject-id');

    if(!subject_id){
      return false;
    }

    if(is_follow){
      // 取消订阅专题
      $.ajax({
          url:'/subject/remove_follow',
          type:"post",
          dataType:"json",
          data:{
              subject_id: subject_id
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                flag = json.flag;
            if(res){
              $ele.removeClass('already').html('订阅');
              if(msg&&flag=="reduce"){
                Page.showTopNotice(msg,'succ');
              }
            }else{
              if(msg){
                Page.showTopNotice(msg,'error');
              }
            }
          }
      });
    }else{
      // 订阅专题
      $.ajax({
          url:'/subject/add_follow',
          type:"post",
          dataType:"json",
          data:{
              subject_id: subject_id
          },
          success:function(json){
            var res = json.res,
                msg = json.msg,
                flag = json.flag;
            if(res){
              $ele.addClass('already').html('取消订阅');
              if(msg && flag=="add"){
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

  function destroy_post(ele){
    var $ele = $(ele),
        post_id = $ele.data('post-id');
    if(!post_id){
      return false;
    };
    Page.showConfirmBox($ele,'确认要删除这篇文章吗？',function(){
      window.location.href="/subject_post/"+post_id+"/destroy";
    });
  }

  function destroy_post_comment(ele){
    var $ele = $(ele),
        comment_id = $ele.data('id');
    Page.showConfirmBox($ele,'确认要删除这条评论吗？',function(){
      Page.remove_box($('.confirmBox'),true);
      $.ajax({
          url:'/subject_post/remove_comment',
          type:"post",
          dataType:"json",
          data:{
              comment_id: comment_id
          },
          success:function(json){
            var res = json.res,
                msg = json.msg;
            if(res){
              if(msg){
                $ele.closest('.comment').slideUp();
                Page.showTopTip(msg,'succ');
              }
            }else{
              if(msg){
                Page.showTopNotice(msg,'error');
              }
            }
          }
      })
    });
  }

  window.switch_favorite = switch_favorite;
  window.add_new_comment = add_new_comment;
  window.load_comments = load_comments;
  window.switch_follow_subject = switch_follow_subject;
  window.destroy_post = destroy_post;
  window.destroy_post_comment = destroy_post_comment;
})