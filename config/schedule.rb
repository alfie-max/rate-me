require File.expand_path(File.dirname(__FILE__) + "/environment")

every 1.day, :at => '2:30 am' do
  runner "User.auto_update", :output => 'log/cron.log'
end
