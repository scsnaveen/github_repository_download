class User < ApplicationRecord
		include AdminCurrent

	attr_accessor :gauth_token
	attr_accessor :executed
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :google_authenticatable,:database_authenticatable, :registerable,
				 :recoverable, :rememberable, :validatable,:confirmable,:trackable,
				 :lockable,:timeoutable
		
		validates :email, format: { :with => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/ }
		validates :last_name, presence: true,length: { maximum: 30 },format: { with: /\A[a-zA-Z]+\z/,message: "only allows letters" }
		validates :first_name, presence: true,length: { maximum: 30 },format: { with: /\A[a-zA-Z]+\z/,message: "only allows letters" }
		validates :user_name,presence: true,uniqueness: true 
		mount_uploader :profile_pic, AvatarUploader
		has_friendship
		has_many :posts
		has_many :messages
		has_many :conversations, foreign_key: :sender_id
		validate :picture_size
		has_paper_trail on: [:destroy,:update], ignore:[:created_at, :updated_at, :track_changes, :last_seen_at, :gauth_tmp , :gauth_tmp_datetime,:current_sign_in_ip,:last_sign_in_ip, :current_sign_in_at, :last_sign_in_at, :sign_in_count, :confirmation_token, :confirmation_sent_at, :confirmed_at]

	# validating picture size	 should be less than 1MB
	def picture_size
		errors.add(:profile_pic, 'should be less than 1MB') if profile_pic.size > 1.megabytes
	end

	# sending a welcome mail after the confirmation
	def after_confirmation
		UserMailer.welcome_email(self).deliver
	end

	def friends?
		self.friends
	end

	def friend_requests?
		self.requested_friends.any?
	end

	def requested_friends?
		self.pending_friends.any?
	end

	def invite_friend(user)
		self.friend_request(user)
	end

	def not_friends
		potential = []
		User.all.each do |user|
			if(self.friends_with?(user) != true && self != user && self.friends.include?(user) != true && self.pending_friends.include?(user) != true && self.requested_friends.include?(user) != true)
				potential << user
			end
		end
		potential
	end

	#getting posts  
	def friends_and_own_posts
		puts friends.pluck(:id).inspect
		myfriends = friends.pluck(:id)
		myfriends << self.id
		our_posts =[]
		our_posts = Post.where('user_id IN (?)', myfriends).order(created_at: "desc")
		our_posts
	end
	rails_admin do 
		edit do
			include_all_fields
			field :confirmation_token do
				read_only true if AdminCurrent.admin_current.role_id != "1"
			end
		end
	end



	# mailing the super admin which are modified in User model 
	after_update :notify, unless: :executed 

	def notify 
		puts "/////////////////////"
		puts AdminCurrent.admin_current.inspect
		if AdminCurrent.admin_current.present?
			if AdminCurrent.admin_current.role_id != "1"
				if self.saved_changes? && !track_changes_previously_changed?
					changed_by = AdminCurrent.admin_current.id
					admin_email = AdminCurrent.admin_current.email
					object_changes = self.versions.last.object_changes
					changes  = [object_changes, "#{admin_email[0..3]}#{changed_by} #{Time.now.strftime("%d-%m-%Y %H:%M ")} "] rescue nil
					user = User.where(id: self.id).first
					user.track_changes << changes
					user.executed = true
					user.save
					changes_for_mail = object_changes.to_s.gsub("=>", " field changed from ").gsub("["," ").gsub("]"," ").gsub("\",","\" to ")
					#sending mail to admin
					UserMailer.track_changes(changes_for_mail,changed_by,"User").deliver_later
				end
			end
		end
	end
end
