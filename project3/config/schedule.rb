env :PATH, ENV['PATH']
set :output, "#{path}/log/cron_log.log"


job_type :script_runner, "cd :path; rails runner :task :output"
job_type :code_runner, "cd :path; rails runner ':task' :output"

# When our application is started, we will populate the current data from BOM
# Then we will initialize predictions for the next 3 hours.
every :reboot do
	script_runner "lib/initialize.rb"
end

# Run the background data retrieval script every 10 minutes
# Here we only make predictions for 10 minutes in the future.
every 10.minutes do 
	script_runner "lib/update.rb"
end
