class UsersController < ApplicationController
	 before_action :authenticate_user!

	def edit
		@user= User.find(params[:id])
	end

	# showing all the users profile 
	def show
		@user = User.find(params[:id])
	end

	# viewing the user profile 
	def my_profile
		@user = current_user
		@posts =current_user.posts
		@friends =current_user.friends
	end

	# updating profile image
	def update
		@user = current_user
		@user.profile_pic = params[:user][:profile_pic]
		if @user.profile_pic.size > 1.megabytes
			redirect_to users_my_profile_path
			flash[:alert] = " Profile pic should be less than 1MB"
		else
			@user.save(validate: false)
			redirect_to users_my_profile_path
		end
	end

end
