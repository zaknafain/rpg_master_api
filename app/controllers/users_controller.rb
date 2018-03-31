class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_admin, only: [:destroy]

  def index
    render json: User.all
  end

  def show
    render json: user
  end

  def destroy
    if user.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def user
    @user ||= User.find(params['id'].to_i)
  end
end
