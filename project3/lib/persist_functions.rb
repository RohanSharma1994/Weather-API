require 'date'

# Used to generate a description
WIND_HEAVY = 35
TEMP_HOT = 30
TEMP_PLEASANT = 20
TEMP_COLD = 10

# Converts rainsince9am to precipIntensity in units mm/10 min
def convert_to_intensity station_name, rain
	# Get the numeric value
	rain = rain.to_f
	if(rain)
		# Find this weather station
		weather_station = WeatherStation.find_by(name:station_name)
		if(weather_station)
			day = weather_station.days.find_by(date:Date.today)
			if(not day)
				# This is the first observation for the day
				return rain.to_f
			else
				# Get the total rain that has fallen today
				total_rain = day.total_rainfall
				# Find out how much more rain has falled since
				# the last increment. This will be the precipitaion
				# intensity in mm/10 minutes
				return (rain - total_rain)
			end
		end
	end
	return 0.0
end

# Returns the description 
def description wind_speed, rain, temperature
	if rain > 0
		return "Rainy"
	elsif wind_speed >= WIND_HEAVY
		return "Windy"
	elsif temperature >= TEMP_HOT
		return "Hot"
	elsif temperature >= TEMP_PLEASANT
		return "Pleasant"
	elsif temperature <= TEMP_COLD
		return "Cold"
	else
		return "Calm"
	end
end

# This persists the weather data into the database
def persist_data name, source, temperature, wind_speed, wind_direction, rain
	# Find the weather station in the database
	weather_station = WeatherStation.find_by(name:name)
	# Check if this weather station exists in the database
	if weather_station
		# Check if there has been a recording today
		day = weather_station.days.find_by(date:Date.today)
		# If there hasn't been a recording today, create one
		if not day
			day = weather_station.days.create(date:Date.today)
		end
		desc = description wind_speed, rain, temperature
		# Add a new observation to today
		observation = day.observations.create(description: desc, source: source)
		# Store the specific observations for this observation
		observation.rainfall = Rainfall.create(rainfall_amount: rain)
		observation.wind = Wind.create(wind_speed: wind_speed, wind_direction: wind_direction)
		observation.temperature = Temperature.create(current_temperature: temperature)
		# Persist
		observation.save
	else 
		puts "#{name} not found my g."
	end
end
