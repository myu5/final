class UsersController < ApplicationController
	before_action :authorize, :only=>[:show]
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
