# encoding: utf-8
World::Application.routes.draw do

  root :to => 'lib#activities'

  match "test",:to=>"subject#test",via:[:get]


  match "group",:to=>"group#index",via:[:get]
  match "group/new",:to=>"group#new",via:[:get]
  
  match "group/create",:to=>"group#create",via:[:post]
  match "group/:name", constraints: { name: /[a-zA-Z0-9_]*/ }, :to=>"group#topic_list",via:[:get]
  match "group/join_group",:to=>"group#join_group",via:[:post] #加入小组 ajax
  match "group/quit_group",:to=>"group#quit_group",via:[:post] #退出小组 ajax
  match "group/:name/new",:to=>"group#new_topic", constraints: { name: /[a-zA-Z0-9_]*/ },via:[:get]
  match "group/:name/create",:to=>"group#create_topic", constraints: { name: /[a-zA-Z0-9_]*/ },via:[:post]
  match "group/:name/:topic_id",:to=>"group#topic", constraints: { name: /[a-zA-Z0-9_]*/, topic_id: /\d+/ },via:[:get]



  match "subject",:to=>"subject#index",via:[:get]
  match "subject/new",:to=>"subject#new",via:[:get]
  
  match "subject/create",:to=>"subject#create",via:[:post]
  match "subject/upload_image",:to=>"subject#upload_image",via:[:post]  # 上传post配图 ueditor 本地文件 ajax
  match "subject/get_remote_image",:to=>"subject#get_remote_image",via:[:post]  #上传post正文配图 ueditor 网络图片 ajax
  match "subject/add_follow",:to=>"subject#add_follow",via:[:post] #订阅专题 ajax
  match "subject/remove_follow",:to=>"subject#remove_follow",via:[:post] #取消订阅专题 ajax

  match "subject_post/:post_id/upload_post_cover_image",:to=>"subject#upload_post_cover_image", constraints: { post_id: /\d+/ },via:[:post] #上传post封面图 ajax
  match "subject_post/:post_id/edit",:to=>"subject#edit_post", constraints: { post_id: /\d+/ },via:[:get] #编辑文章
  match "subject_post/:post_id/update",:to=>"subject#update_post", constraints: { post_id: /\d+/ },via:[:post]
  match "subject_post/:post_id/destroy",:to=>"subject#destroy_post", constraints: { post_id: /\d+/ },via:[:get] #删除文章

  match "subject_post/add_favorite",:to=>"subject#add_favorite",via:[:post] #喜欢文章 ajax
  match "subject_post/remove_favorite",:to=>"subject#remove_favorite",via:[:post] #取消喜欢文章 ajax
  match "subject_post/add_comment",:to=>"subject#add_comment",via:[:post] #评论文章 ajax
  match "subject_post/remove_comment",:to=>"subject#remove_comment",via:[:post] #取消评论文章 ajax
  match "subject_post/comment_list",:to=>"subject#comment_list",via:[:get] #文章的评论列表 ajax


  match "subject:id/:tag",:to=>"subject#tag_post_list", constraints: {id: /\d+/ },via:[:get]
  match "subject/:identify",:to=>"subject#post_list", constraints: { identify: /[a-zA-Z0-9_]*/ }, via:[:get]
  match "subject/:identify/follower",:to=>"subject#follower_list", constraints: { identify: /[a-zA-Z0-9_]*/ },via:[:get]
  match "subject/:identify/:post_id",:to=>"subject#post", constraints: { identify: /[a-zA-Z0-9_]*/, post_id: /\d+/ },via:[:get]
  match "subject/:identify/new",:to=>"subject#new_post", constraints: { identify: /[a-zA-Z0-9_]*/ },via:[:get]
  match "subject/:identify/create",:to=>"subject#create_post", constraints: { identify: /[a-zA-Z0-9_]*/ },via:[:post]


  #个人中心
  match "my/message",:to=>"my#message_page",via:[:get]
  match "my/message/history",:to=>"my#message_history_page",via:[:get]

  match ":uid",:to=>"center#index_page", constraints: {uid: /\d+/ },via:[:get]
  match ":uid/favorite",:to=>"center#favorite_page", constraints: {uid: /\d+/ },via:[:get]
  match ":uid/comment",:to=>"center#comment_page", constraints: {uid: /\d+/ },via:[:get]
  match ":uid/subject",:to=>"center#subject_page", constraints: {uid: /\d+/ },via:[:get]
  match ":uid/follow",:to=>"center#follow_page", constraints: {uid: /\d+/ },via:[:get]
  match ":uid/fans",:to=>"center#fans_page", constraints: {uid: /\d+/ },via:[:get]

  match ":uid/demo",:to=>"center#center_demo", constraints: {uid: /\d+/ },via:[:get]

  match "ueditor",:to=>"site2#ueditor",via:[:get]

  #上传预裁剪头像, => 裁剪并创建头像, 创建头像(远程图片)
  match "user/upload_crop_avatar",:to=>"user#upload_crop_avatar",via:[:post]
  match "user/save_avatar",:to=>"user#save_avatar",via:[:post]
  match "user/save_remote_avatar",:to=>"user#save_remote_avatar",via:[:post]

  match "user/add_follow",:to=>"user#add_follow",via:[:post] #关注用户 ajax
  match "user/remove_follow",:to=>"user#remove_follow",via:[:post] #取消关注用户 ajax
  match "user/chat",:to=>"user#chat",via:[:post] #发送私信 ajax


  match "ip",:to=>"lib#ip",via:[:get]

  match "weixin",:to=>"lib#weixin",via:[:get,:post]

  # 登录相关
  match 'signin',:to=>"login#signin",via:[:get,:post]
  match 'signout',:to=>'login#signout',via:[:get]  # 登出  view || ajax
  match 'signup',:to=>"login#signup",via:[:get,:post]
  
  match 'accountInfo',:to=>'login#accountInfo',via:[:post] # 当前登录用户的信息 ajax

  match 'login/weibo_login',:to=>"login#weibo_login",via:[:get,:post]
  match 'login/weibo_callback',:to=>"login#weibo_callback",via:[:get,:post]
  
  match 'login/renren_login',:to=>"login#renren_login",via:[:get,:post]
  match 'login/renren_callback',:to=>"login#renren_callback",via:[:get,:post] 

  match 'login/kaixin_login',:to=>"login#kaixin_login",via:[:get,:post]
  match 'login/kaixin_callback',:to=>"login#kaixin_callback",via:[:get,:post] 

  match 'login/qq_login',:to=>"login#qq_login",via:[:get,:post]
  match 'login/qq_callback',:to=>"login#qq_callback",via:[:get,:post] 

  match 'login/douban_login',:to=>"login#douban_login",via:[:get,:post]
  match 'login/douban_callback',:to=>"login#douban_callback",via:[:get,:post] 

  get "lib/settings"
  get "lib/settings_fresh"

end