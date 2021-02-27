Rails.application.routes.draw do
	

	devise_for :admins,:controllers => {
		:registrations => "admins/registrations",
		:sessions => "admins/sessions",
		:confirmations => "admins/confirmations"
	}
	devise_scope :admin do  
		get '/admins/sign_out' => 'admins/sessions#destroy'     
	end

	#routing for users
	devise_for :users,:controllers => {
		:registrations => "users/registrations",
		:sessions => "users/sessions",
		:confirmations => "users/confirmations",
		:passwords =>"users/passwords",
		:omniauth_callbacks_controller=>"users/omniauth_callbacks_controller"
	}
	devise_scope :user do  
	 get '/users/sign_out' => 'users/sessions#destroy'     
	end
	get 'users/my_profile'
	resources :users, only: [:show,:update,:edit]
	# for posts
	resources :post, only: [:new,:index]
	post 'post/create'
	delete 'post/delete'

	# devise_for 
	mount RailsAdmin::Engine => '/admin', as: 'rails_admin'


	get 'welcome/index'
	root 'post#index'
	
	# for friendships
	post "/friendships/add" => "friendships/add"
	post "/friendships/reject" => "friendships/reject"
	post "/friendships/remove" => "friendships/remove"
	get "/friendships/search" => "friendships/search"
	post "/friendships/search" => "friendships/search"
	post "/friendships/block"=>"friendships/block"
	post "/friendships/unblock"=>"friendships/unblock"
	resources :friendships, only: [:index, :create]

	# for conversation and messages
	resources :conversations, only: [:create,:index] do
		member do
				post :close
		end
	resources :messages, only: [:create]
	end
		
	namespace :admin do
		get 'dashboard/index'
		get 'admins/sign_in'
	end
end
