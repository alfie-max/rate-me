require File.expand_path(File.dirname(__FILE__) + "/environment")

every 1.day, :at => '11:45 pm' do
  runner "User.auto_update", :output => 'log/cron.log'
end
