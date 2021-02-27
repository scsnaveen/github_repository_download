Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  devise_for :users,:controllers => {
		:registrations => "users/registrations",
		:sessions => "users/sessions"
	}
devise_scope :user do  
	 get '/users/sign_out' => 'users/sessions#destroy'     
	end
	get 'projects/download'
	get 'projects/new'
	post 'projects/create'
	# get 'home/down-git.js'
	# get 'home/home.js'
	# get 'app.js'
	# get 'app/site.css'
	# get '/lib/angular-toastr(2.0.0).min.css'
	# get '/lib/angular-toastr(2.0.0).tpls.min.css'
	# get '/lib/filesaver.min.js'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
