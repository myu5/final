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

	def show
		@user = User.find_by(id: params[:id])
	end
	def edit

		
	end

	def update
		@user.user_name = params[:user_name]
		@user.email = params[:email]
		@user.gender = params[:gender]
		@user.photo_url = params[:photo_url]
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
				@user.password = params[:new_password]
				if @user.save
					redirect_to "/users/#{session["user_id"]}", notice: "You have updated your Password!"
					return
				else
					redirect_to "/change_password/#{session["user_id"]}/edit_password", notice: "Failed updating password, try again!"
				end
		else
			redirect_to "/change_password/#{session["user_id"]}/edit_password", notice: "You Entered the Wrong Old Password."
		end
	end


	def create
		@user = User.new(user_name: params[:user_name], password: params[:password],email: params[:email], gender: params[:gender], create_date: Time.now, photo_url: params[:photo_url], background: params[:background])
		if @user.save
			redirect_to root_url, notice: "Thanks for Signing UP!"
		else
			render "new"
		end
	end
end
