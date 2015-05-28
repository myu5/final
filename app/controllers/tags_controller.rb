class TagsController < ApplicationController
	def index
		@tags = Tag.order('name asc')
	end
	def show
		@recipes = Tag.find_by(id: params[:id]).recipes.paginate(:page => params[:page], :per_page => 10)
		#Wait to be displayed
	end
	def new
	end
	def create
	end
end