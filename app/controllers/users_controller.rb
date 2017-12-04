class UsersController < ApplicationController
  before_action :authenticate_user

  def index
    render json: User.all.to_json
  end

  def show

  end 
end
