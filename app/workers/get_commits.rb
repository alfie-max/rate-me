class GetCommits
  include Sidekiq::Worker

  def perform(user, email, token, repos_url)
    User.get_commit(user, email, token, repos_url)
  end
end
