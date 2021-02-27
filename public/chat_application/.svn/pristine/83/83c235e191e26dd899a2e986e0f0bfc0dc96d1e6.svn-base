class Admin < ApplicationRecord
	include AdminCurrent
	devise :database_authenticatable,
				 :recoverable, :rememberable, :validatable,:confirmable, :timeoutable,:trackable
	
	#email validation
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_format_of :email,:with => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/

	belongs_to :role
	has_paper_trail on: [:destroy,:update], ignore:[:created_at, :updated_at,:current_sign_in_ip, :track_changes,:last_sign_in_ip, :current_sign_in_at, :last_sign_in_at, :sign_in_count, :confirmation_token, :confirmation_sent_at, :confirmed_at]

	attr_accessor :executed

	def create_model_enum
		["User","Role","Friendship","Message","Post","Conversation"]
	end

	def read_model_enum
		["User","Role","Friendship","Message","Post","Conversation","Admin"]
	end

	def update_model_enum 
		["User","Friendship","Message","Post","Conversation","Admin"]
	end

	def delete_model_enum 
		["Friendship","Message","Post","Conversation"]
	end

	rails_admin do 
		edit do
			include_all_fields 
			field :create_model, :enum do
				render do
					bindings[:form].select( "create_model", bindings[:object].create_model_enum, {}, { multiple: true })
				end
			end
			field :update_model, :enum do
				render do
					bindings[:form].select( "update_model", bindings[:object].update_model_enum, {}, { multiple: true })
				end
			end
			field :read_model, :enum do
				render do
					bindings[:form].select( "read_model", bindings[:object].read_model_enum, {}, { multiple: true })
				end
			end
			field :delete_model, :enum do
				render do
					bindings[:form].select( "delete_model", bindings[:object].delete_model_enum, {}, { multiple: true })
				end
			end
		end
	end

	# for  mapping create model
	def self.create_model_array(id)

		admin = Admin.find(id).create_model
		create_model_array =[]
		if !admin.nil? && admin.present?
			create_model_array = admin.map{|n|eval n}.reject(&:blank?)
		end

		return create_model_array
	end

	# for mapping read model
	def self.read_model_array(id)

		admin = Admin.find(id).read_model
		read_model_array =[]
		if !admin.nil? && admin.present?
			read_model_array = admin.map{|n|eval n}.reject(&:blank?)
		end

		return read_model_array
	end

	# for  mapping update model
	def self.update_model_array(id)

		admin = Admin.find(id).update_model
		update_model_array =[]
		if !admin.nil? && admin.present?
			update_model_array = admin.map{|n|eval n}.reject(&:blank?)
		end

		return update_model_array
	end

	# for  mapping delete model
	def self.delete_model_array(id)

		admin = Admin.find(id).delete_model
		delete_model_array =[]
		if !admin.nil? && admin.present?
			delete_model_array = admin.map{|n|eval n}.reject(&:blank?)	
		end

		return delete_model_array
	end

		# mailing the super admin which are modified in Admin model by admin and executive 
		after_update :notify, unless: :executed 
		def notify 
			if AdminCurrent.admin_current.present?
				if AdminCurrent.admin_current.role_id != "1"
					if self.saved_changes? && !track_changes_previously_changed?
						changed_by = self.versions.last.whodunnit
							admin_email = Admin.where(id: changed_by).first.email rescue nil
							object_changes = self.versions.last.object_changes
							changes  = [object_changes, "#{admin_email[0..3]}#{changed_by} #{Time.now.strftime("%d-%m-%Y %H:%M ")} "] rescue nil
							admin = Admin.where(id: self.id).first
							puts changes.inspect
							admin.track_changes << changes
							admin.executed = true
							admin.save
							changes_for_mail = object_changes.to_s.gsub("=>", " field changed from ").gsub("["," ").gsub("]"," ").gsub("\",","\" to ")
							#sending mail to admin
							UserMailer.track_changes(changes_for_mail,changed_by,"Admin").deliver_later
							# self.executed = true
					end
				end
			end
		end
end
