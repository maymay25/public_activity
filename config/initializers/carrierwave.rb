
CarrierWave.configure do |config|
  config.delete_tmp_file_after_storage = true
  config.ignore_download_errors = false
  config.cache_dir = "#{Rails.root}/public/assets/uploads/tmp/cache/"

  
  config.aliyun_access_id = "JdZTrWwRkmXfbO4n"
  config.aliyun_access_key = '55DrhqC7AdMZwQM4m3rIAgYPphav4T'
  # # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
  config.aliyun_bucket = "suixin365"
  # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
  if Rails.env == "production"
    config.storage = :aliyun
    config.aliyun_internal = true
    #config.aliyun_host = "suixin365.oss-internal.aliyuncs.com"
    config.aliyun_host = "img.suixin365.com"
  else
    config.storage = :file
  end
  # # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
  # # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
  #config.aliyun_host = "suixin365.oss.aliyuncs.com"

  #

end
