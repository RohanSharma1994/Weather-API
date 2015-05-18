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
env :PATH, ENV['PATH']
set :output, "#{path}/log/cron_log.log"


job_type :script_runner, "cd :path; rails runner :task :output"
job_type :code_runner, "cd :path; rails runner ':task' :output"

every 1.minutes do 
	script_runner "lib/load_bom.rb"
end
