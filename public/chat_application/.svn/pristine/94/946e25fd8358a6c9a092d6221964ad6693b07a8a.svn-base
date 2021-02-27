# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
	 before_action :sign_up_params, only: [:create]
	 before_action :configure_account_update_params, only: [:update]

	# GET /resource/sign_up
	def new
		 @user = User.new
	end

	# creating a new user 
	def create
		@user = User.new(sign_up_params)
		if @user.save
			redirect_to new_user_session_path
		else
			render 'new'
		end
	end

	 protected

	# If you have extra params to permit, append them to the sanitizer.
	def sign_up_params
		params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation,:gender,:date_of_birth,:profile_pic)
	end

	# If you have extra params to permit, append them to the sanitizer.
	def configure_account_update_params
		devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :user_name, :email, :password, :current_password,:gender,:date_of_birth,:profile_pic)}
	end

	# POST /resource
	# def create
	#   super
	# end

	# GET /resource/edit
	# def edit
	#   super
	# end

	# PUT /resource
	# def update
	#   super
	# end

	# DELETE /resource
	# def destroy
	#   super
	# end

	# GET /resource/cancel
	# Forces the session data which is usually expired after sign
	# in to be expired now. This is useful if the user wants to
	# cancel oauth signing in/up in the middle of the process,
	# removing all OAuth session data.
	# def cancel
	#   super
	# end


	# The path used after sign up.
	# def after_sign_up_path_for(resource)
	#   super(resource)
	# end

	# The path used after sign up for inactive accounts.
	# def after_inactive_sign_up_path_for(resource)
	#   super(resource)
	# end
end
