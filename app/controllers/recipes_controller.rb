class RecipesController < ApplicationController
  before_action :find_recipe, :only => [:show, :edit, :update, :destroy]

  def find_recipe
  	@recipe = Recipe.find_by(id: params["id"])
  	#Todo : generate stars from reviews
  	@recipe.stars = 4
  	@recipe.save
  end

  def index
  	@recipes = Recipe.order('title asc')
  	@recipes.each do |rcp|
  		#Todo : generate stars from reviews
  		rcp.stars = 4
  	end
  end

  def show
  	if @recipe == nil
  		redirect_to recipes_url, notice: "recipe not found."
    else
      @tags = @recipe.tags
  	end

  end

  def new
    if !cookies["user_id"].present?
      redirect_to recipes_url, notice: "Sorry...You have to Sign In in order to post Recipe!"
    end
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
    @recipe.stars = 4
    @recipe.num_reviews = 0
    @recipe.user_id = cookies["user_id"]
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
  	@recipe.delete
  	redirect_to recipes_url

  end
end
