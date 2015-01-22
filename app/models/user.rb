require 'open-uri'
require 'json'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

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
      rescue JSON::ParserError
      end
    end

    return commits
  end
end
