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
  	end
  end

  def new
  end

  def create
  	recipe = Recipe.new
  	recipe.title = params[:title]
  	recipe.photo_url = params[:photo_url]
  	recipe.instruction = params[:instruction]
  	recipe.date = Time.now
  	recipe.save
  	redirect_to recipes_url, notice: "New Recipe is saved."
  end

  def edit
  end

  def update
  	@recipe.title = params[:title]
  	@recipe.date = Time.now
  	@recipe.instruction = params[:instruction]
  	@recipe.photo_url = params[:photo_url]
  	@recipe.save
  	redirect_to recipes_url, notice: "recipe is updated"
  end

  def destroy
  	@recipe.delete
  	redirect_to recipes_url

  end

end
