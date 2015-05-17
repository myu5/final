class User < ActiveRecord::Base
	has_many :recipes
	has_many :reviews

	validates_presence_of :user_name
	validates_presence_of :email
	validates_presence_of :password
	validates_uniqueness_of :user_name
	validates_uniqueness_of :email
	validates_presence_of :gender
	validates_presence_of :create_date
end
