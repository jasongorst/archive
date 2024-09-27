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

# job_type :rake, "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"

# override default rake job to remove --silent switch
job_type :rake, "cd :path && :environment_variable=:environment bundle exec rake :task :output"

set :output, "log/cron.log"

every 1.day, at: "3:00 am" do
  runner "script/fetch_new_messages.rb"
  runner "script/fetch_new_private_messages.rb"
end

every "@reboot" do
  rake "ts:start"
end
