class GetReputation
  include Sidekiq::Worker

  def perform(uid, token)
    User.get_user_reputation(uid, token)
  end
end
