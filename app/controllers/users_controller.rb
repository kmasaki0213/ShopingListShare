class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @user = current_user
    @teams = current_user.teams
  end  

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    if current_user != User.find(params[:id])
      redirect_to root_path, alert: '他のユーザーのプロフィールは編集できません。'
    end
    @user = current_user
  end
  

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :team_id, :password, :password_confirmation)
    end
end
