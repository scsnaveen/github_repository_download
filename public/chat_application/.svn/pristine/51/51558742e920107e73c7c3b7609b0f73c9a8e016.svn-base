class Conversation < ApplicationRecord
		include AdminCurrent
	has_many :messages, dependent: :destroy
	belongs_to :sender, foreign_key: :sender_id, class_name: "User"
	belongs_to :recipient, foreign_key: :recipient_id, class_name: "User"

	validates :sender_id, uniqueness: { scope: :recipient_id }

	scope :between, -> (sender_id, recipient_id) do
		where(sender_id: sender_id, recipient_id: recipient_id).or(
			where(sender_id: recipient_id, recipient_id: sender_id)
		)
	end
	has_paper_trail on: [:destroy,:update], ignore:[:created_at, :updated_at, :track_changes]

	def self.get(sender_id, recipient_id)
		conversation = between(sender_id, recipient_id).first
		return conversation if conversation.present?

		create(sender_id: sender_id, recipient_id: recipient_id)
	end

	def opposed_user(user)
		user == recipient ? sender : recipient
	end

	# mailing the super admin which are modified in Conversation model 
	after_update :notify rescue nil

	def notify 
		if AdminCurrent.admin_current.present?
			if AdminCurrent.admin_current.role_id != "1"
				if self.saved_changes? && !track_changes_previously_changed?
					changed_by = self.versions.last.whodunnit
					admin_email = Admin.where(id: changed_by).first.email rescue nil
					object_changes = self.versions.last.object_changes
					changes  = [object_changes, "#{admin_email[0..3]}#{changed_by} #{Time.now.strftime("%d-%m-%Y %H:%M ")} "] rescue nil
					conversation = Conversation.where(id: self.id).first
					conversation.track_changes << changes
					conversation.save
					changes_for_mail = object_changes.to_s.gsub("=>", " field changed from ").gsub("["," ").gsub("]"," ").gsub("\",","\" to ")
					#sending mail to admin
					UserMailer.track_changes(changes_for_mail,changed_by,"Conversation").deliver_later
				end
			end
		end
	end
end