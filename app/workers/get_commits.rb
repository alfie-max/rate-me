class GetCommits
  include Sidekiq::Worker

  def perform(user, email, token)
    User.get_user_commits(user, email, token)
  end
end
