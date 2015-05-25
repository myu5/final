class RecipesController < ApplicationController
  before_action :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_action :find_recipe, :only => [:authorize, :show, :edit, :update, :destroy]
  before_action :authorize, :only => [:edit, :update, :destroy]
  

  def find_recipe
  	@recipe = Recipe.find_by(id: params[:id])
  	#Todo : generate stars from reviews
  end

  def require_user
    if !session[:user_id].present?
      redirect_to root_url, notice: "You have to Sign In to Perform the action."
      return
    end
  end

  def authorize
    if @recipe.user_id != session["user_id"].to_i
      redirect_to root_url, notice: "You can't edit or delete Recipe not Posted by you."
      return
    end
  end



  def index
  	if params["keyword"].present?
      @recipes = Recipe.where("title LIKE ?", "%#{params[:keyword]}%")
    else
      @recipes = Recipe.all
    end

    @recipes = @recipes.order('title asc')
    
  end

  def show
  	if @recipe == nil
  		redirect_to recipes_url, notice: "recipe not found."
    else
      @tags = @recipe.tags
  	end
    @review = Review.new
    @reviews = Review.where(recipe_id: @recipe.id).order('date desc')

  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new
  	@recipe.title = params[:title]
  	@recipe.photo_url = params[:photo_url]
    @recipe.ingredients = params[:ingredients]
  	@recipe.instruction = params[:instruction]
    @recipe.duration = params[:duration]
  	@recipe.date = Time.now
    @recipe.stars = 0
    @recipe.num_reviews = 0
    @recipe.user_id = session["user_id"]
    if @recipe.save
      redirect_to recipes_url, notice: "New Recipe is saved."
    else
      render 'new'
    end
    
  end

  def edit
    
  end

  def update
  	@recipe.title = params[:title]
    @recipe.ingredients = params[:ingredients]
  	@recipe.date = Time.now
  	@recipe.instruction = params[:instruction]
  	@recipe.photo_url = params[:photo_url]
    puts @recipe.ingredients
    if @recipe.save
      redirect_to recipe_url(@recipe.id), notice: "recipe is updated"
    else
      render "edit"
    end
  end

  def destroy
    @recipe.transaction do
      reviews = @recipe.reviews
      reviews.each do |review|
        review.delete
      end
      @recipe.delete
  	end
  	redirect_to recipes_url

  end
end
