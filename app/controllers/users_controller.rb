class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_owner, only: [:update]
  before_action :authenticate_admin, only: [:destroy]

  def index
    render json: User.all
  end

  def show
    render json: user
  end

  def update
    if user.update_attributes(user_params)
      head :no_content
    else
      head :bad_request
    end
  end

  def destroy
    if user.destroy
      head :no_content
    else
      head :bad_request
    end
  end

  private

  def authenticate_owner
    head :forbidden and return unless current_user.id == user.id || current_user.admin?
  end

  def user
    @user ||= User.find(params['id'].to_i)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email, :name)
  end
end
