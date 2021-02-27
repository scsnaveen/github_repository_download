class UserMailer < ApplicationMailer
	
	# welcome mail after confirmation
	def welcome_email(user)
		@user = user
		mail(:from =>"CHAT railschecking@gmail.com",to: @user.email, subject: "Welcome!")
	end

	#friend request mail informing mail for the friend
	def friend_request_mail(user)
		@user = user
		mail(:from =>"CHAT railschecking@gmail.com",to: @user.email, subject: "Friend request")
	end

	#sending mail for the admin when modified
	def track_changes(changes,changed_by,model_name)
		@changes = changes.gsub(" &quot;","")
		puts changed_by
		puts Admin.all.inspect
		@changed_by = Admin.find(changed_by)
		@model_name = model_name
		mail(:from =>"CHAT railschecking@gmail.com",:to =>ENV["SUPER_ADMIN_MAIL"],:subject => "Admin with id-#{@changed_by.id}, role #{@changed_by.role.role_name.gsub("_"," ")} updated #{@model_name} table")
	end
end
