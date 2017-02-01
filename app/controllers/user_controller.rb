	class UserController < ApplicationController
		skip_before_filter :verify_authenticity_token  

		def create
			@user = User.create( user_params )
			if @user.save
				generateCoverPic(@user)
			end
		end

		def new
		end

		def generateCoverPic(user)
			first_image  = MiniMagick::Image.open("#{Rails.root}/public/overlay.png")
			end_index = user.avatar.url.rindex('?')
			url = user.avatar.url[0..end_index-1]
			second_image = MiniMagick::Image.open("#{Rails.root}/public#{url}")
			second_image.resize "2480x2480"
			result = second_image.composite(first_image) do |c|
  				c.compose "Over"    # OverCompositeOp
  				c.geometry "+0+0" # copy second_image onto first_image from (20, 20)
  			end	
  			send_file(
  				result.path,
  				filename: "dp." + result.type.to_s,
  				type: "image/png"
  				)
  		end	

  		private
  		def user_params
  			params.require(:user).permit(:avatar)
  		end
  	end
