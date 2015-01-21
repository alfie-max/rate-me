class GetCommits
  include Sidekiq::Worker

  def perform(user, email, token)
    User.get_commit(user, email, token)
  end
end
