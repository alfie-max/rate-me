require 'open-uri'
require 'json'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :default_url => "/images/missing.jpg"
  validates_attachment_content_type :avatar, :content_type => ["image/jpeg", "image/gif", "image/png", "image/jpg" ]

  def self.get_user_commits(user, email, token)
    access_token = "?access_token=" + token
    user_repos_url = "https://api.github.com/users/" + user + "/repos" + access_token
    commits = get_repos_commits(user_repos_url, token, user)

    orgs_url = "https://api.github.com/users/" + user + "/orgs" + access_token
    orgs = JSON.parse(open(orgs_url).read)
    orgs.each do |org|
      org_repos_url = "https://api.github.com/orgs/" + org["login"] + "/repos" + access_token
      commits += get_repos_commits(org_repos_url, token, user)
    end

    user = User.find_by_email(email)
    user.update(g_commits: commits)
  end

  def self.get_repos_commits(repos_url, token, user)
    access_token = "?access_token=" + token
    repos = JSON.parse(open(repos_url).read)
    commits = 0

    repos.each do |repo|
      repo_url = repo["contributors_url"] + access_token
      begin
        contributors = JSON.parse(open(repo_url).read)
        contributors.each do |contributor|
        commits += contributor["contributions"] if contributor["login"] == user
        end
      rescue JSON::ParserError, OpenURI::HTTPError
      end
    end

    return commits
  end

  def self.get_user_reputation(uid, token)
    user_api = "https://api.stackexchange.com/2.2/users/"
    path = "?order=desc&sort=reputation&site=stackoverflow"
    token_key = "&access_token=" + token.to_s + "&key=" + ENV["SE_KEY"]
    user_info_url = user_api + uid.to_s + path + token_key
    user_info = JSON.parse(open(user_info_url).read)
    reps =  user_info["items"][0]["reputation"]
    user = User.find_by_s_uid(uid)
    user.update(s_reputation: reps)
  end
end
