require 'rubygems'
require 'daemons'

commend = ARGV[0] || 'start'
current_path = File.expand_path('..', __FILE__)
%W[
  album.off.subscribed.rb
  album.on.subscribed.rb
  album.updated.dj.subscribed.rb
  audio.queue.subscribed.rb
  biting.subscribed.rb
  comment.created.dj.subscribed.rb 
  favorite.created.dj.subscribed.rb
  following.batchcreated.dj.subscribed.rb
  following.created.dj.subscribed.rb
  following_tag.batchcreated.dj.subscribed.rb
  following_tag.created.dj.subscribed.rb
  message.created.dj.subscribed.rb
  push.subscribed.rb
  relay.created.dj.subscribed.rb
  set_newest20d.rb
  track.played.subscribed.rb
  thirdparty.fans.subscribed.rb
  track.off.subscribed.rb
  track.on.subscribed.rb
  user.off.subscribed.rb
].each do |s|
  system("ruby #{File.join(current_path, s)} #{commend}")
end

system('ps -ef|grep subscribe.rb')
