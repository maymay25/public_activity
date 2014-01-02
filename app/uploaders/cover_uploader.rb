# encoding: utf-8
require 'carrierwave/processing/mime_types'

class CoverUploader < CarrierWave::Uploader::Base

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
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  #等比例裁剪
  def jcrop
    manipulate! do |img|
      min = [img.rows,img.columns].min
      x = (0.5*(img.columns - min)).to_i
      y = (0.5*(img.rows - min)).to_i
      img = img.crop(x, y, min, min)
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

  version :big, :from_version => :large do 
    process :resize_to_fill  => [124, 124]
  end

  version :medium, :from_version => :big do 
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
