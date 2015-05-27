# A custom rake task which predicts the weather 10 minutes in the future 
# each time it is called. It does so by regressing on data from the past
# seven days around this time of the day. 
# This is done for every weather station.
require_relative 'regression.rb'
namespace :prediction do
	desc "Makes a prediction 10 minutes in the future for every weather station."
	task :predict => :environment do
		WEEK = 7
		LIMIT = 4
		# Get a list of all weather stations
		weather_stations = WeatherStation.all
		# Get the current time
		current_time = Time.now.strftime("%H:%M:%S")
		# For each of these weather stations, a prediction will be made
		for weather_station in weather_stations
			puts "Predicting for #{weather_station.name}..."
			# Get the last week of observations for this weather station
			# if they are available
			days = weather_station.days.where("created_at >= ?", 1.week.ago)

			# Data structures for regression
			temperature = []
			wind_speed = []
			wind_direction = []
			rain = []
			time = []
			count = 0

			if(not weather_station.days or weather_station.days.length == 0)
				next
			end
			# If there is less than 4 days of data just regress on today's data
			# to ensure more accuracy.
			if(days.length <= LIMIT) 
				day = weather_station.days.find_by(date:Date.today)
				for observation in day.observations
					# Add to the time array
					time.push count
					count += 1
					# Add each of the specific observations
					temperature.push observation.temperature.current_temperature
					wind_speed.push observation.wind.wind_speed
					wind_direction.push observation.wind.wind_direction
					rain.push observation.rainfall.rainfall_amount
				end
			else
				# Otherwise regress on all the days around this time of the day.
				# For each of these days collect datapoints required for regression
				for day in days
					# Find the observation around this time of the day
					observation = day.observations.find_by("time(created_at) >= ?", current_time)
					# Add to the time array 
					time.push count
					count += 1
					# Add each of the specific observations
					temperature.push observation.temperature.current_temperature
					wind_speed.push observation.wind.wind_speed
					wind_direction.push observation.wind.wind_direction
					rain.push observation.rainfall.rainfall_amount
				end
			end

			# Ensure there is enough data
			if count == 0
				next
			end

			# Perform regression for each of these observations
			regression = Regression.new
			# Regress and predict the temperature
			regression.regress time, temperature
		    predicted_temperature = regression.extrapolate count
		    temperature_variance = regression.r_2
		    # Regress and predict the wind speed
		    regression.regress time, wind_speed
		    predicted_wind_speed = regression.extrapolate count
		    wind_speed_variance = regression.r_2
		    # Regress and predict the wind direction
		    regression.regress time, wind_direction
		    predicted_wind_direction = regression.extrapolate count
		    wind_direction_variance = regression.r_2
		    # Regress and predict the rain 
		    regression.regress time, rain
		    predicted_rain = regression.extrapolate count
		    rain_variance = regression.r_2

		    # Store this prediction for this weather station
		    prediction = weather_station.predictions.create(
		    	temperature_variance: temperature_variance,
		    	wind_speed_variance: wind_speed_variance,
		    	wind_direction_variance: wind_direction_variance,
		    	rain_variance: rain_variance
		    )
		    prediction.temperature = Temperature.create(current_temperature: predicted_temperature)
		    prediction.wind = Wind.create(wind_speed: predicted_wind_speed, wind_direction: predicted_wind_direction)
		    prediction.rainfall = Rainfall.create(rainfall_amount: predicted_rain)
		    prediction.save
		end
	end
end
