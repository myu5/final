class UsersController < ApplicationController
	before_action :authorize, :only=>[:edit, :update, :edit_password, :update_password]
	def authorize
		@user = User.find_by(id: params[:id])
		if !@user || session[:user_id].blank? || session[:user_id] != @user.id
			redirect_to root_url, notice: "Nice Try!"
			return
		end
	end
	def new
		@user = User.new
	end

	def create
		@user = User.new
		@user.user_name= params[:user_name]
		@user.password= params[:password]
		@user.email= params[:email] 
		@user.gender= params[:gender]
		@user.create_date= Time.now 
		if params[:photo_url].present? && params[:photo_url] != ""
			@user.photo_url = params[:photo_url]
		else
			@user.photo_url = "default-user-image.png"
		end
		@user.background= params[:background]
		if params[:password]== params[:confirm_password]
			if @user.save
				redirect_to root_url, notice: "Thanks for Signing UP!"
				return
			else
				render 'new'
				return
			end
		else
			flash[:notice] = "The two password entered do not match."
			render 'new'
		end
		
	end
	def show
		@user = User.find_by(id: params[:id])
		@recipes = @user.recipes
	end
	def edit

		
	end

	def update
		@user.user_name = params[:user_name]
		@user.email = params[:email]
		@user.gender = params[:gender]
		if params[:photo_url].present? && params[:photo_url] != ""
			@user.photo_url = params[:photo_url]
		else
			@user.photo_url = "default-user-image.png"
		end

		@user.background = params[:background]
		puts @user.password
		if @user.save
			redirect_to "/users/#{session["user_id"]}", notice: "You have updated your Profile!"
			return
		else
			render "edit"
		end
	end
	def edit_password
	
	end

	def update_password
		if @user.authenticate(params[:old_password])

			if params[:new_password]==params[:confirm_password]
				@user.password = params[:new_password]
				if @user.save
					redirect_to "/users/#{session["user_id"]}", notice: "You have updated your Password!"
					return
				else
					redirect_to "/change_password/#{session["user_id"]}/edit_password", notice: "Failed updating password, try again!"
					return
				end
			else
				redirect_to "/change_password/#{session["user_id"]}/edit_password", notice: "The two password you entered do not match!"
				return
			end
			
		else
			redirect_to "/change_password/#{session["user_id"]}/edit_password", notice: "You Entered the Wrong Old Password."
			return
		end
	end


	
end
