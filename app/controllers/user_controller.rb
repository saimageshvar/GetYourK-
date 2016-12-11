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
			base_url = ""
			first_image  = MiniMagick::Image.open("#{base_url}/base.jpg")
			second_image = MiniMagick::Image.open("l#{base_url}#{user.avatar.url}")
			second_image.resize "200x200"
			result = first_image.composite(second_image) do |c|
  				c.compose "Over"    # OverCompositeOp
  				c.geometry "+586+84" # copy second_image onto first_image from (20, 20)
  			end	
  			send_file(
  			result.path,
  			filename: user.id,
  			type: "image/png"
  			)
  		end	

  		private
  		def user_params
  			params.require(:user).permit(:avatar)
  		end
  	end
