# A function which predicts the weather for each weather station
# Libraries required:
require_relative 'regression.rb'
WEEK = 7
LIMIT = 4
THREE_HOURS = 18
ANGLE = 360

# Amount of predictions to make
def make_prediction amount
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
				wind_direction.push observation.wind.wind_direction%ANGLE
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
				wind_direction.push observation.wind.wind_direction%ANGLE
				rain.push observation.rainfall.rainfall_amount
			end
		end
		# Ensure there is enough data
		if count == 0
			next
		end

		# Perform regression for each of these observations
		regression = Regression.new

		# Extrapolate
		x = count
		# In this case only one prediction needs to be made 3 hours in the future
		if amount == 1 and weather_station.predictions.count == THREE_HOURS
			for prediction in weather_station.predictions
				temperature.push prediction.temp
				wind_speed.push prediction.wind_spd
				wind_direction.push prediction.wind_dir%ANGLE
				rain.push prediction.rain
				time.push count
				count += 1
			end
		end
		while x < (count + amount)
			# Regress the temperature
			regression.regress time, temperature
	    	temperature_variance = regression.r_2
			predicted_temperature = regression.extrapolate x
			# Regress the rain 
			regression.regress time, rain
			rain_variance = regression.r_2
			predicted_rain = regression.extrapolate x
			# Regress the wind direction
			regression.regress time, wind_direction
			wind_direction_variance = regression.r_2
			predicted_wind_direction = regression.extrapolate x
			# Regress the wind speed
			regression.regress time, wind_speed
			wind_speed_variance = regression.r_2
			predicted_wind_speed = regression.extrapolate x


			# Store this prediction for this weather station
			prediction = weather_station.predictions.create(
		 		temperature_variance: temperature_variance,
		   		wind_speed_variance: wind_speed_variance,
		   		wind_direction_variance: wind_direction_variance,
		   		rain_variance: rain_variance
			)
			prediction.temperature = Temperature.create(current_temperature: predicted_temperature)
			prediction.wind = Wind.create(wind_speed: predicted_wind_speed, wind_direction: predicted_wind_direction%ANGLE)
	    	prediction.rainfall = Rainfall.create(rainfall_amount: predicted_rain)
	    	puts "Making a prediction for '#{weather_station.name}': Temperature: #{predicted_temperature}, Wind Speed: #{predicted_wind_speed}, Wind Direction: #{predicted_wind_direction%ANGLE}, Predicted Rain: #{predicted_rain}"
			prediction.save
			x+=1
		end
    end
end
