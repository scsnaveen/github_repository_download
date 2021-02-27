module RailsAdmin
  module Config
    module Actions
    class OnlineMembers < RailsAdmin::Config::Actions::Base
    	RailsAdmin::Config::Actions.register(self)
        register_instance_option :collection do  #	this is for specific record
          true
        end
        

        register_instance_option :controller do
         Proc.new do
               @online_users = User.where("last_seen_at > ?",5.minutes.ago) 
         end
        end
         register_instance_option :link_icon do
          # font awesome icons. but an older version
          'fa fa-users'
        end
      end  
    end
  end
end