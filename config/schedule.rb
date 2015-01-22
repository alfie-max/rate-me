require File.expand_path(File.dirname(__FILE__) + "/environment")

every 1.day, :at => '11:02 pm' do
  users = User.all
  users.each do |user|
    login = user.g_login
    email = user.email
    g_token = user.g_token
    uid = user.s_uid
    s_token = user.s_token
    runner "User.delay.get_user_commits('" + login.to_s + "','" + email + "','" + g_token.to_s + "')", output: 'log/cron.log'
    runner "User.delay.get_user_reputation('" + uid.to_s + "','" + s_token.to_s + "')", output: 'log/cron.log'
  end
end
