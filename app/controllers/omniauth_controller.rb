class OmniauthController < ApplicationController

  def github
    auth = request.env["omniauth.auth"]
    user = User.find_by_email(auth["info"]["email"])
    if user
      user.update(github: :true, g_uid: auth.uid,
                  g_login: auth.extra.raw_info.login,
                  g_token: auth.credentials.token,
                  repos_url: auth.extra.raw_info.repos_url)
      flash[:notice] = "Your Github account has been Synced !!"
      redirect_to root_url
    else
      flash[:notice] = "Registered email id doesn't match the github account email id !!"
      redirect_to root_url
    end
  end

end
