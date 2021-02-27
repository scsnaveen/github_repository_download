class ConversationsController < ApplicationController
		before_action :authenticate_user!

	# creating a conversation 
	def create

		@conversation = Conversation.get(current_user.id, params[:user_id])
		# verifying if a conversation is present else it will create new session
		add_to_conversations unless conversated?

		respond_to do |format|
			format.js
		end
	end

	# closing the conversation
	def close
		@conversation = Conversation.find(params[:id])

		session[:conversations].delete(@conversation.id)

		respond_to do |format|
			format.js
		end
	end

	# indexing all the conversations between friends 
	def index
		session[:conversations] ||= []

		@users = current_user.friends
		@conversations = Conversation.includes(:recipient, :messages).find(session[:conversations])
	end

	private
	#creates a session for a conversation
	def add_to_conversations
		session[:conversations] ||= []
		session[:conversations] << @conversation.id
	end
 
	def conversated?
		session[:conversations].include?(@conversation.id)
	end

end