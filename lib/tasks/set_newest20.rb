#!/usr/bin/env ruby
# 最新20条缓存
# "newest20.#{category.id}"
#
require File.expand_path('../../config/environment', __FILE__)

scheduler = Rufus::Scheduler.start_new
scheduler.every '1h' do
  logger ||= Logger.new(File.join(CORE_ROOT, "log/set_newest20.log"))
  logger.info(Time.new.to_s)
  Category.select('id, title').each do |category|
    recomm_ids = RECOMMEND_SERVICE.recentVTrackList(category.id, nil, 1, 20)
    
    if recomm_ids and recomm_ids.size > 1
      tracks = []
      recomm_ids_to_del = []
      recomm_ids[1..-1].each do |id|
        track = Track.stn(id).where(id: id, is_public: true, is_deleted: false, is_publish: true).select('id, title, album_title, intro, uid, cover_path').first
        if track
          tracks << track 
        else
          recomm_ids_to_del << id 
        end
      end

      if tracks.size > 0
        CREDIS.with{|r| r.set(Settings.pagedata.newest20.sub(':id', category.id.to_s), Marshal.dump(tracks))}
        logger.info("#{category.id} #{category.title} #{tracks.size}")
      end

      if recomm_ids_to_del.size > 0
        BACKEND_SERVICE.delRecentVTrack(category.id, nil, recomm_ids_to_del)
        logger.info("del #{category.id} #{recomm_ids_to_del.join(',')}")
      end
    end
  end
end

scheduler.join
