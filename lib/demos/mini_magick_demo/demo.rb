#!/usr/bin/env ruby
# encoding: utf-8
# 图片裁剪 测试
# You must have ImageMagick or GraphicsMagick installed.

# homepage : https://github.com/minimagick/minimagick

# MiniMagick gives you access to all the commandline options ImageMagick has (Found here http://www.imagemagick.org/script/mogrify.php)

require 'mini_magick'

[1..17].each do |i|
    image = MiniMagick::Image.open("_#{i}.jpg")
    image.rotate "-90>"
    
end



# 单个图片操作
# [4,5,7].each do |i|
# 	image = MiniMagick::Image.open("_#{i}.jpg")
# 	image.resize "160x160"
# 	image.write  "#{i}.jpg"
# end
# -----------------------------------------------------------------------------

# 多个图片合并（可以批量打水印）
# origin_image = MiniMagick::Image.open("input.jpg")
# addition_image = MiniMagick::Image.open("addition.png")

# result_image = origin_image.composite(addition_image) do |c|
#   c.gravity "center"
# end

# result_image.write  "composite_#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.jpg"

