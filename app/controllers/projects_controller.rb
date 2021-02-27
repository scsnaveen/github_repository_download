require 'zip'

class ProjectsController < ApplicationController
	def index
		@trunk = system "svn ls #{@project.url}/trunk"
		@branches = system "svn ls #{@project.url}/branches" 
	end
	def new 
		@project= Project.new()
	end
	def create
		@project = Project.new(project_params)
		@project.user_id = current_user.id
		puts "========================"
		if @project.url ==""
			redirect_to projects_new_path,alert: "enter url"
		else
			split_url = @project.url.split('/')
			@project.name = split_url[4]
			# @trunk = system "svn ls #{@project.url}/trunk"
			# @branches = system "svn ls #{@project.url}/branches" 
			# @project.owner =split_url[3]
			system "svn checkout #{@project.url} #{Rails.root}/public/#{@project.name}" 
			folder = "/Users/naveen/Desktop/test/gitrepo/public/#{split_url[4]}"

	Dir["#{Rails.root}/public/#{@project.name}"].each do |file|
		  if File.directory?(file)
		    `zip -r "#{file}.zip" "#{file}"`
		  end
		end
			puts "#{Rails.root}/public/#{@project.name}".inspect
			send_file "#{Rails.root}/public/#{@project.name}.zip"
			system "rake stats #{Rails.root}/public/#{@project.name}"
			puts system "find #{Rails.root}/public/#{@project.name}   -name '*.html' -exec wc {} + | sort -n"
			puts system "find #{Rails.root}/public/#{@project.name}   -name '*.css' -exec wc {} + | sort -n"    
			puts system "find #{Rails.root}/public/#{@project.name}   -name '*.rb' -exec wc {} + | sort -n"  
		end
		@project.save
	end
	
	def project_params
		params.permit(:url,:owner,:name,:folder,:subfolder,:technology,:user_id)
	end
end
