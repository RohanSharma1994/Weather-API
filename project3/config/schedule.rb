env :PATH, ENV['PATH']
set :output, "#{path}/log/cron_log.log"


job_type :script_runner, "cd :path; rails runner :task :output"
job_type :code_runner, "cd :path; rails runner ':task' :output"

# Run the background data retrieval script
every 5.minutes do 
	script_runner "lib/load_bom.rb"
end
