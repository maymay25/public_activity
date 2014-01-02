# encoding: utf-8
require 'carrierwave/processing/mime_types'

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

  include CarrierWave::RMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if Rails.env=="production"
      return "carrierwave/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      return "#{Rails.root}/public/assets/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end


  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    if model.gender == User::GENDER[:female]
      default_name = "female.png"
    else
      default_name = "male.png"
    end
    "/assets/avatars/user/" + [version_name, default_name].compact.join('_')
  end

  #等比例裁剪
  def jcrop
    # p model.crop_x
    # p model.crop_y
    # p model.crop_h
    # p model.crop_w
    # p model.crop_oh
    # p model.crop_ow
    # p "---------------#{Time.now}-------------"
    
    manipulate! do |img|

      # puts img.rows #图片的高度
      # puts img.columns #图片的宽度

      #使用大图等比例裁剪，保证分辨率
      if model.crop_w.to_i*model.crop_h.to_i*model.crop_oh.to_i*model.crop_ow.to_i > 0
        mutiple_x = img.columns.to_f/model.crop_ow
        mutiple_y = img.rows.to_f/model.crop_oh

        x = (mutiple_x*model.crop_x).to_i
        y = (mutiple_y*model.crop_y).to_i
        w = (mutiple_x*model.crop_w).to_i
        h = (mutiple_y*model.crop_h).to_i
        img = img.crop(x, y, w, h)
      else
        min = [img.rows,img.columns].min
        x = (0.5*(img.columns - min)).to_i
        y = (0.5*(img.rows - min)).to_i
        img = img.crop(x, y, min, min)
      end
      img
    end

  end

  
  version :cover do
    process :jcrop
    process :resize_to_fill  => [260, 260]
  end

  version :large, :from_version => :cover do 
    process :resize_to_fill  => [180, 180]
  end

  version :medium, :from_version => :large do 
    process :resize_to_fill  => [100, 100]
  end

  version :normal, :from_version => :medium do
    process :resize_to_fill  => [60, 60]
  end

  version :small, :from_version => :normal do
    process :resize_to_fill  => [30, 30]
  end



  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
