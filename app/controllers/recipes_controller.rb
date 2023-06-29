class RecipesController < ApplicationController
  before_action :authorize

  def index
    recipes = find_user.recipes
    # byebug
    render json: recipes, status: :ok
  end

  def create
    recipe = find_user.recipes.create(recipe_params)
    # #<Recipe id: nil, title: nil, instructions: "This is too short", minutes_to_complete: 10, user_id: 1, created_at: nil, updated_at: nil>
    #  it's still creating a new recipe with ^^^^
    if recipe.valid?
      render json: recipe, status: :created
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.permit :title, :instructions, :minutes_to_complete
  end

  def find_user
    User.find(session[:user_id])
  end

  def authorize
    return render json: { errors: ["Not_authorized"] }, status: :unauthorized unless session.include? :user_id
  end
end
