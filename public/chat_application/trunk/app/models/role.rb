class Role < ApplicationRecord
	include AdminCurrent

	has_many :admins
	has_paper_trail on: [:destroy,:update], ignore:[:created_at, :updated_at, :track_changes]
	# mailing the super admin which are modified in Role model 
	after_update :notify 

	def notify 
		if AdminCurrent.admin_current.present?
			if AdminCurrent.admin_current.role_id != "1"
				if self.saved_changes? 
					changed_by = self.versions.last.whodunnit
					admin_email = Admin.where(id: changed_by).first.email 
					object_changes = self.versions.last.object_changes
					changes  = [object_changes, "#{admin_email[0..3]}#{changed_by} #{Time.now.strftime("%d-%m-%Y %H:%M ")} "] rescue nil
					role = Role.where(id: self.id).first
					role.track_changes << changes
					role.save
					changes_for_mail = object_changes.to_s.gsub("=>", " field changed from ").gsub("["," ").gsub("]"," ").gsub("\",","\" to ")
					#sending mail to admin
					UserMailer.track_changes(changes_for_mail,changed_by,"Role").deliver_later
				end
			end
		end
	end

end