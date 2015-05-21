class ReviewsController < ApplicationController
  
  def index
    @reviews = Review.find_by(recipe_id: params[:recipe_id])
    @reviews = @reviews.order('date desc')
  end

  def show
    if @review == nil
      redirect_to reviews_url, notice: "Review not found!"
    end
  end


  def new
  end

  def create
    @review = Review.new
    @review.title = params[:title]
    @review.comment = params[:comment]
    @review.date = Time.now
    @review.stars = params[:stars].to_i
    @review.recipe_id = params[:recipe_id]
    @review.user_id = cookies[:user_id]
    
    @reviews = Review.where(recipe_id: params[:recipe_id]).order('date desc')
    if @review.save
      redirect_to recipe_url(:id => params[:recipe_id])
    else
      @recipe = Recipe.find_by(id: params[:recipe_id])
      @tags = @recipe.tags
      render '/recipes/show'
    end
  end

  def destroy
    review = Review.find_by(id: params[:id])
    review.delete
    redirect_to recipe_url(id: params[:recipe_id])
  end

end