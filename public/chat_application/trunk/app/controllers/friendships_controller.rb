class FriendshipsController < ApplicationController
	before_action :authenticate_user!

	# index for the friends,requested friends,pending friends & blocked friends
	def index
		@user = current_user
		@friends = @user.friends
		@requests = @user.requested_friends
		@pending = @user.pending_friends
		@blocked= @user.blocked_friends
	end

	# for sending a request to the friend
	def create        
		@user = current_user
		friend = User.find_by(id: params[:id])
		@user.friend_request(friend)
		UserMailer.friend_request_mail(friend).deliver
		redirect_to friendships_path 
		flash[:notice]= "Friend request has been sent to #{friend.user_name}"
	end

	# accepting the request from a friend
	def add
		@user = current_user
		friend = User.find_by(id: params[:id])
		@user.accept_request(friend)
		redirect_to friendships_path
		flash[:notice]="You are now friend with #{friend.user_name}"
	end

	# blocking a friend
	def block
		@user = current_user
		friend = User.find_by(id: params[:id])
		@user.block_friend(friend)

		redirect_to friendships_path
	end

	# unblocking a friend
	def unblock
		@user = current_user
		friend = User.find_by(id: params[:id])
		@user.unblock_friend(friend)

		redirect_to friendships_path
	end

	# rejecting the friend request
	def reject
		@user = current_user
		friend = User.find_by(id: params[:id])
		@user.decline_request(friend)
		redirect_to friendships_path
		flash[:alert] = "You have cancelled the friend request of #{friend.user_name}"
	end

	# removing from a friend
	def remove
		@user = current_user
		friend = User.find_by(id: params[:id])
		@user.remove_friend(friend)
		redirect_to friendships_path
		flash[:alert] = "You unfriend  #{friend.user_name}"
	end

	# searching for a friend
	def search
		@search = params[:search].downcase
		@results = User.all.select do |user|
			user.user_name.downcase.include?(@search)
		end
	end

end
