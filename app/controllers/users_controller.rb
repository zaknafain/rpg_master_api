class UsersController < ApplicationController
  before_action :authenticate_user

  def index
    render json: User.all.to_json
  end

  def show
    user = User.find(params['id'].to_i)

    render json:  user.to_json
  end
end
