require Rails.root.join('lib', 'rails_admin' , 'online_members.rb')

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == CancanCan ==
    config.authorize_with :cancancan
    

  ## == Pundit ==
  # config.authorize_with :pundit
  # config.parent_controller = 'ApplicationController' 
  # config.authorize_with do
  #   redirect_to main_app.root_path unless current_admin.role.role_name ? "super_admin" : "admin"
  # end

  ## == PaperTrail ==
   config.audit_with :paper_trail, 'Admin', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    online_members do 
      visible do 
        bindings[:abstract_model].model.to_s == "User"
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
