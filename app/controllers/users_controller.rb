class UsersController < ApplicationController
	def new
		@user = User.new
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
