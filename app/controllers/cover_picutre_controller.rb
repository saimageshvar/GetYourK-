class CoverPicutreController < ApplicationController
	def create
		first_image  = MiniMagick::Image.open("#{Rails.root}/public/base.jpg")
		second_image = MiniMagick::Image.open("#{Rails.root}/public/over.jpg")
		second_image.resize "200x200"
		result = first_image.composite(second_image) do |c|
  			c.compose "Over"    # OverCompositeOp
  			c.geometry "+586+84" # copy second_image onto first_image from (20, 20)
  		end	
  		result.write "#{Rails.root}/public/output.jpg"
  		send_file(
  			result.path,
  			filename: 'asdad',
  			type: "image/png"
  			)
  	end
  end
