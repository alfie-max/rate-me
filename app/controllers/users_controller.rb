class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def sync_github
      GetCommits.perform_async(current_user.g_login, current_user.email,
                              current_user.g_token)
      # User.delay.get_user_commits(current_user.g_login, current_user.email,
      #                       current_user.g_token)
      redirect_to user_path(current_user)
  end

  def sync_stackoverflow
      GetReputation.perform_async(current_user.s_uid, current_user.s_token)
      redirect_to user_path(current_user)
  end

  private

    def user_params
      params.require(:user).permit(:avatar)
    end
end
