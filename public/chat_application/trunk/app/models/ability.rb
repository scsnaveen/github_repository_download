# frozen_string_literal: true
require 'rails_admin/main_controller'

module RailsAdmin

	class MainController < RailsAdmin::ApplicationController
		# rescue for the admins who cannot access  
		rescue_from CanCan::AccessDenied do |exception|
			redirect_to rails_admin.dashboard_path
			flash[:alert] = 'Access denied.'
		end
	end
end

class Ability
	include CanCan::Ability

	def initialize(admin)
		if admin
			can :access, :rails_admin
			can :dashboard ,:all
			can :read, :dashboard
			
			# Super Admin can manage all
			if admin.role.role_name == "super_admin"
				can :manage, :all

			#Admin can access which are allowed by super admin
			elsif admin.role.role_name == "admin"

				can :online_members,:all 
				can :create,Admin.create_model_array(admin.id)
				can :read,Admin.read_model_array(admin.id)
				can :update,Admin.update_model_array(admin.id)
				can :destroy,Admin.delete_model_array(admin.id)

			#executive can access which are allowed by super admin
			elsif  admin.role.role_name == "executive"
				can :create,Admin.create_model_array(admin.id)
				can :read,Admin.read_model_array(admin.id)
				can :update,Admin.update_model_array(admin.id)
				can :destroy,Admin.delete_model_array(admin.id)
			end
		end
	end
end
