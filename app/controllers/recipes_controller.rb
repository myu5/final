class RecipesController < ApplicationController
  before_action :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_action :find_recipe, :only => [:authorize, :show, :edit, :update, :destroy]
  before_action :authorize, :only => [:edit, :update, :destroy]
  before_action :find_tags, :only =>[:index, :new, :create, :edit, :update]

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
  def find_tags
    @tags = Tag.all
  end


  def index
  	if params["keyword"].present?
      @recipes = Recipe.where("title LIKE ?", "%#{params[:keyword]}%")
    else
      @recipes = Recipe.all
    end

    @recipes = @recipes.order('stars desc').paginate(:page => params[:page],:per_page => 10)

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
    tags = @recipe.tags
    @marked = {}
    tags.each do |tag|
      @marked[tag.id] = true
    end

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
    @recipe.transaction do   
      @recipe.save
      @recipe.categories.each do |rc|
        rc.delete
      end
      @tags.each do |tag|
        if params["TagID#{tag.id}"].present?
          cate = Category.new
          cate.recipe_id = @recipe.id
          cate.tag_id = tag.id
          cate.save
        end
      end
    end

    if !@recipe.errors.any?
      redirect_to recipes_url, notice: "New Recipe is saved."
      return
    else
      @marked = {}
      @tags.each do |tag|
        if params["TagID#{tag.id}"].present?
          @marked[tag.id]= true
        end
      end
      render 'new'
    end
    
  end

  def edit
    tags = @recipe.tags
    @marked = {}
    tags.each do |tag|
      @marked[tag.id] = true
    end
  end

  def update
    @recipe.transaction do
      @recipe.title = params[:title]
      @recipe.ingredients = params[:ingredients]
      @recipe.date = Time.now
      @recipe.instruction = params[:instruction]
      @recipe.photo_url = params[:photo_url]
      @recipe.save

      @recipe.categories.each do |rc|
        rc.delete
      end
      @tags.each do |tag|
        if params["TagID#{tag.id}"].present?
          cate = Category.new
          cate.recipe_id = @recipe.id
          cate.tag_id = tag.id
          cate.save
        end

      end
    end

    if !@recipe.errors.any?
      redirect_to recipe_url(@recipe.id), notice: "recipe is updated"
      return
    else
      tags = @recipe.tags
      @marked = {}
      tags.each do |tag|
        @marked[tag.id]= true
      end

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
