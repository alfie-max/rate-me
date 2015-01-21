class OmniauthController < ApplicationController

  def github
    auth = request.env["omniauth.auth"]
    current_user.update(github: "true", g_uid: auth.uid,
                        g_login: auth.extra.raw_info.login,
                        g_token: auth.credentials.token)

    GetCommits.perform_async(current_user.g_login, current_user.email,
                              current_user.g_token)

    flash[:notice] = "Your Github account has been Synced !!"
    redirect_to root_url
  end

  def stackexchange
    auth = request.env["omniauth.auth"]
    if User.find_by_s_uid(auth["uid"])
      flash[:notice] = "A user is already synced with this account.
                        Please check if logged in account is yours."
    else
      current_user.update(s_uid: auth.uid,
                          stackoverflow: "true",
                          s_reputation: auth.extra.raw_info.reputation,
                          s_token: auth.credentials.token)
      flash[:notice] = "Your StackOverflow account has been Synced !!"
      redirect_to root_url
    end
  end
end
