class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(user_name: params[:user_name])
		if user
			if user.authenticate(params[:password])
				session["user_id"] = user.id
				redirect_to root_url, notice: "Welcome back!"
			else
				redirect_to '/login', notice: "Wrong Password"
			end
		else
			redirect_to '/login', notice: "Unknown User Name."
		end
	end
	def destroy
		session.delete :user_id
		redirect_to root_url, notice: "You have signed out!"
	end

end