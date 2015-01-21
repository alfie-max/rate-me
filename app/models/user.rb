require 'open-uri'
require 'json'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.get_commit(user, email, token, repos_url)
    access_token = "?access_token=" + token
    repos_url = "https://api.github.com/users/" + user + "/repos" + access_token
    orgs_url = "https://api.github.com/users/" + user + "/orgs" + access_token
    repos = JSON.parse(open(repos_url).read)
    commits = 0
    repos.each do |repo|
      repo_url = repo["contributors_url"] + access_token
      begin
        contributors = JSON.parse(open(repo_url).read)
        contributors.each do |contributor|
          if contributor["login"] == user
            commits += contributor["contributions"]
          end
        end
      rescue JSON::ParserError
      end
    end
    user = User.find_by_email(email)
    user.update(g_commits: commits)
  end
end
