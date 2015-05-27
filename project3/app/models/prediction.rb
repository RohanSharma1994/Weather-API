ONE_PERIOD = 10
# Radius of earth in km
RADIUS = 6371
# Normalizes distance
DISTANCE_NORMALIZER = 25.0
# Normalizes predictions
# Since the client can only ask for
# predictions 3 hours in the future,
# this number is 18.
PREDICTION_NORMALIZER = 18.0
require 'json'
require 'open-uri'
require 'date'

# The prediction retrieval system
class Prediction < ActiveRecord::Base
	# Relationships
	belongs_to :weather_station
	has_one :rainfall
	has_one :temperature
	has_one :wind

	# Converts angle to radians
	def self.to_radians angle
		angle * Math::PI / 180
	end

	# Methods
	# Returns the distance between two latitudes and longitudes
	def self.distance lat1, lon1, lat2, lon2
		d_lat = to_radians (lat2 - lat1)
		d_lon = to_radians (lon2 - lon1)
		a = (Math.sin(d_lat/2))**2 + Math.cos(to_radians lat1)*Math.cos(to_radians lat2)*(Math.sin(d_lon/2))**2
		c = 2*Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
		# Return the distance
		RADIUS*c
	end

	# A class method which gets the prediction for a post code.
	# Postcode: Post code to get the prediction for
	# Period: enum(10,30,60,120,180)
	# Returns the predictions for that period and postcode
	def self.post_code_prediction post_code, period
		# Find the latitude and longitude of this post code using another API
		base_url = 'http://v0.postcodeapi.com.au/suburbs/'
		json = JSON.parse(open("#{base_url}"+post_code+".json").read)
		if json[0]
			lat = json[0]["latitude"]
			lon = json[0]["longitude"]
		else
			# This post code isn't a victorian post code according to postcodeapi
			# Just return empty array
			return []
		end
		lat_lon_prediction period, lat, lon
	end

	# A class method which returns the average of 3 values
	def self.average val1, val2, val3
		(val1+val2+val3)/3.0
	end

	# A class method which returns the probability of a prediction.
	# Takes in a number to indicate how far out a prediction is being made
	# to calculate rough probability of extrapolation.
	# Distance: Distance to the closest weather station.
	def self.variance val1, val2, val3, prediction, distance

		# Get the average variance
		avg_variance = average val1, val2, val3
		# Initially probability can be the average variance
		probability = avg_variance
		# As distance increases, the accuracy of our predictions decrease.
		# This can be modelled by constricting distances in between 0 to 1.
		# Take distance into account first, also take into account how far we are predicting in the future
		probability = avg_variance - (2.0/Math::PI)*Math.atan(distance/DISTANCE_NORMALIZER + prediction/PREDICTION_NORMALIZER)
	end

	# A class method which gets the predictions for a given latitude,
	# longitude and period.
	# Period: enum{10,30,60,120,180}
	# lat: Latitude
	# lon: Longitude
	# Returns the predictions for that period
	def self.lat_lon_prediction period, lat, lon
		period = period.to_f
		lat = lat.to_f
		lon = lon.to_f
		# Get all the weather stations
		weather_stations = WeatherStation.all
		array = []

		# For each of these weather stations calculate the distance from the lat and lon
		for weather_station in weather_stations
			distance = distance lat, lon, weather_station.lat, weather_station.lon
			# Store this distance in an array of hash maps
			array.push({"weather_station" => weather_station, "distance" => distance})
		end

		# Sort the array based on distances 
		array = array.sort_by { |k| k["distance"]}
		# Get the 3 closest weather stations to create a triangular encapsulating region
		array = array[0..2]

		# Put the number of predictions asked for inside the array of hash maps.
		array.each_index do |i|
			weather_station = array[i]["weather_station"]
			# Get the latest predictions from the database for this weather station
			# The first prediction will represent the current conditions
			array[i]["predictions"] = weather_station.predictions.limit(period/ONE_PERIOD + 1).order('created_at asc')
		end

		# The final hash to respond with
		hash = {}
		# Need to normalize time as we make background predictions
		time = Time.now
		
		# Aggregate the predictions from the three weather stations which surround the datapoint
		array[0]["predictions"].each_index do |i|
			# Take the average of predictions from the three stations
			one = array[0]["predictions"][i]
			two = array[1]["predictions"][i]
			three = array[2]["predictions"][i]

			# The probability of our predictions wane as time increases
			# Initially the probability can be the average variance of the three weather stations
			rain_variance = variance one.rain_variance, two.rain_variance, three.rain_variance, i, array[0]["distance"]
			temp_variance = variance one.temperature_variance, two.temperature_variance, three.temperature_variance, i, array[0]["distance"]
			wind_spd_variance = variance one.wind_speed_variance, two.wind_speed_variance, three.wind_speed_variance, i, array[0]["distance"]
			wind_dir_variance = variance one.wind_direction_variance, two.wind_direction_variance, three.wind_direction_variance, i, array[0]["distance"]
			avg_temp = average one.temp, two.temp, three.temp
			avg_rain = average one.rain, two.rain, three.rain
			avg_wind_spd = average one.wind_spd, two.wind_spd, three.wind_spd
			avg_wind_dir = average one.wind_dir, two.wind_dir, three.wind_dir
			hash["#{i*ONE_PERIOD}"] = {
				"time" => "#{time.strftime('%H:%M%P %d-%m-%Y')}",
				"rain" => {
					"value" => "#{avg_rain.round(2)}mm",
					"probability" => "#{rain_variance.round(2)}"
				},
				"temp" => {
					"value" => "#{avg_temp.round(2)}",
					"probability" => "#{temp_variance.round(2)}"
				},
				"wind_speed" => {
					"value" => "#{avg_wind_spd.round(2)}",
					"probability" => "#{wind_spd_variance.round(2)}"
				},
				"wind_direction" => {
					"value" => "#{avg_wind_dir.round(2)}",
					"probability" => "#{wind_dir_variance.round(2)}"
				}
			}
			# Add 10 minutes to the normalized time
			time = time + ONE_PERIOD*60
		end
		return hash
	end

	# Returns the amount of rain for this prediction
	def rain
		self.rainfall.rainfall_amount
	end

	# Returns the amount of wind_speed for this prediction
	def wind_spd
		self.wind.wind_speed
	end

	# Returns the amount of wind_direction for this prediction
	def wind_dir
		self.wind.wind_direction
	end

	# Returns the amount of temperature for this prediction
	def temp
		self.temperature.current_temperature
	end
end
