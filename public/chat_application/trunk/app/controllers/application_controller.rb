module AdminCurrent
	mattr_accessor :admin_current
	
end
class ApplicationController < ActionController::Base
	# who is resposible for the changes 
	before_action :set_paper_trail_whodunnit
	before_action :set_current_admin 
	protect_from_forgery with: :exception, prepend: true

	def set_current_admin
		if current_admin
			AdminCurrent.admin_current = current_admin
		end
	end
	# update last seen after user sign in
	before_action :update_last_seen_at, if: -> { user_signed_in? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 2.minutes.ago) }
	
	#updating last seen for current user
	def update_last_seen_at
		if current_user.present?
			current_user.update_attribute(:last_seen_at,Time.now)
		end
	end

	
	# after sign in path for user and admin
	def after_sign_in_path_for(resource)
		stored_location_for(resource) ||
		if resource.is_a?(User)
			root_path
		elsif resource.is_a?(Admin)
			rails_admin_path
		else
			root_path
		end
	end

end
