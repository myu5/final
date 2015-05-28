require 'net/smtp'
require 'mailfactory'
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
				if @user.photo_url == "default-user-image.png"
					@user.photo_url=""
				end
				render 'new'
				return
			end
		else
			flash[:notice] = "The two password entered do not match."
			if @user.photo_url == "default-user-image.png"
				@user.photo_url=""
			end
			render 'new'
		end
		
	end
	def show
		@user = User.find_by(id: params[:id])
		@recipes = @user.recipes
	end
	def edit
		if @user.photo_url == "default-user-image.png"
			@user.photo_url=""
		end
		
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
			if @user.photo_url == "default-user-image.png"
				@user.photo_url=""
			end
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
					render "edit_password"
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

	def forget_password
	end

	def generate_password
		chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789'
		length = 10
		return Array.new(length) { chars[rand(chars.length)].chr }.join
	end
	def send_password
		send_to = params[:email_address]
		user = User.find_by(:email => send_to)
		if !user.present?
			redirect_to forget_password_path, notice: "Email Address Not Found!!"
			return
		end

		user.password = generate_password
		if !user.save
			redirect_to forget_password_path, notice: "Failed to Generate Password, Please try again!"
			return
		end

		mail = MailFactory.new
		mail.from = "noreply@recipe.com"
		mail.to = send_to
		mail.subject = "New password for your Recipe account"
		mail.text = "Dear #{user.user_name}:\n\nYour new password is #{user.password}.\n\nSent by Recipe.com"
		host = "smtp.mandrillapp.com"
		port = 587
		sender = "lsliusen1986@gmail.com"
		key = "lPYuVe53FBSZfTFaGuS9-w"
		Net::SMTP.start(host,port,'mandrillapp.com',sender,key) do |smtp|
			smtp.send_message(mail.to_s,sender,mail.to)
		end
		redirect_to root_path, notice: "A new password Has Been Sent To Your Email!!!"
		return
	end

	
end
