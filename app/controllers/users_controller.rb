class UsersController < ApplicationController
  before_action :authenticate_user

  def index
    render json: User.all
  end

  def show
    user = User.find(params['id'].to_i)

    render json: user
  end
end
