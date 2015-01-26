class UsersController < ApplicationController
  before_filter :get_rank_list, only: [:index]

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def sync_github
      GetCommits.perform_async(current_user.g_login, current_user.email,
                              current_user.g_token)
      # User.delay.get_user_commits(current_user.g_login, current_user.email,
      #                       current_user.g_token)
      redirect_to root_url
  end

  def sync_stackoverflow
      GetReputation.perform_async(current_user.s_uid, current_user.s_token)
      redirect_to root_url
  end

  private

    def get_rank_list
      @users = User.all
      @rank_list = points = Array.new
      @users.each do |user|
        points << [user.id, (user.g_commits.to_i + user.s_reputation.to_i)]
      end

      scores = points.to_h.values.sort.reverse
      scores.each do |score|
          points.each do |point|
              if point[1] == score
                @rank_list << points.delete(point)
                break
              end
          end
      end
    end
end
