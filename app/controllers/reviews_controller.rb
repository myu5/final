class ReviewsController < ApplicationController
  
  before_action :require_user, :only =>[:new, :create, :destroy]
  before_action :authorize, :only =>[:destroy]
  def require_user
    if !session[:user_id].present?
      redirect_to root_url, notice: "You have to Sign In to Post Review."
      return
    end
  end
  def authorize
    @review = Review.find_by(id: params[:id])
    if @review.user_id != session["user_id"].to_i
      redirect_to recipe_url(id: params[:recipe_id]), notice: "You can't delete Other User's Review"
      return
    end

  end

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
    @review.user_id = session[:user_id]
    @review.transaction do
      @review.save
      recipe = @review.recipe
      recipe.num_reviews += 1
      recipe.stars = recipe.reviews.sum(:stars) / recipe.num_reviews
      recipe.save
    end
    @reviews = Review.where(recipe_id: params[:recipe_id]).order('date desc')
    if @review.errors.present?
      @recipe = Recipe.find_by(:id => params[:recipe_id])
      render "/recipes/show", notice: @review.errors.messages
    else
      redirect_to recipe_url(:id => params[:recipe_id])
    end
  end

  def destroy
    @review.transaction do
      @review.delete
      recipe = @review.recipe
      recipe.num_reviews = recipe.num_reviews - 1
      if recipe.num_reviews==0
        recipe.stars=0
      else
        recipe.stars = recipe.reviews.sum(:stars)/recipe.num_reviews
      end
      recipe.save
    end
    @reviews = Review.where(recipe_id: params[:recipe_id]).order('date desc')
    if @review.errors.present?
      @recipe = Recipe.find_by(:id => params[:recipe_id])
      render "/recipes/show", notice: @review.errors.messages
    else
      redirect_to recipe_url(:id => params[:recipe_id])
    end
  end

end