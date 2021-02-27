class Message < ApplicationRecord
	include AdminCurrent

	belongs_to :user
	belongs_to :conversation
	after_create_commit { MessageBroadcastJob.perform_later(self) }
	has_paper_trail on: [:destroy,:update], ignore:[:created_at, :updated_at, :track_changes]
	# mailing the super admin which are modified in Message model 
	after_update :notify

	def notify 
		if AdminCurrent.admin_current.present?
			if AdminCurrent.admin_current.role_id != "1"
				if self.saved_changes? && !track_changes_previously_changed?
					changed_by = self.versions.last.whodunnit
					admin_email = Admin.where(id: changed_by).first.email rescue nil
					object_changes = self.versions.last.object_changes
					changes  = [object_changes, "#{admin_email[0..3]}#{changed_by} #{Time.now.strftime("%d-%m-%Y %H:%M ")} "] rescue nil
					message = Message.where(id: self.id).first
					message.track_changes << changes
					message.save
					changes_for_mail = object_changes.to_s.gsub("=>", " field changed from ").gsub("["," ").gsub("]"," ").gsub("\",","\" to ")
					#sending mail to admin
					UserMailer.track_changes(changes_for_mail,changed_by,"Message").deliver_later
				end
			end
		end
	end
end
