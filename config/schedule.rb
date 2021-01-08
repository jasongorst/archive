# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, 'log/cron.log'

every 1.day, at: '2:55 am' do
  rake 'ts:restart'
end

every 1.day, at: '3:00 am' do
  runner 'script/fetch_new_slack_messages.rb'
end

every 1.week, at: 'Sunday 4:00 am' do
  rake 'ts:index'
end

every '@reboot' do
  rake 'ts:start'
end

every 1.day, at: '12:01 am' do
  rake 'ts:start'
end
