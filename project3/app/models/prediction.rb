ONE_PERIOD = 10
class Prediction < ActiveRecord::Base
	# Relationships
	belongs_to :weather_station
	has_one :rainfall
	has_one :temperature
	has_one :wind

	# Methods
	# Returns the distance between two latitudes and longitudes
	def self.distance lat1, lon1, lat2, lon2
		d_lat = lat2 - lat1
		d_lon = lon2 - lon1
		a = ((Math.sin(d_lat/2))**2 + Math.cos(lat1)*Math.cos(lat2)*Math.son(d_lon/2))**2
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
		lat = json[0]["latitude"]
		lon = json[0]["longitude"]
		lat_lon_prediction period, lat, lon
	end

	# A class method which gets the predictions for a given latitude,
	# longitude and period.
	# Period: enum{10,30,60,120,180}
	# lat: Latitude
	# lon: Longitude
	# Returns the predictions for that period
	def self.lat_lon_prediction period, lat, lon
		# Get all the weather stations
		weather_stations = WeatherStation.all
		array = []

		# For each of these weather stations calculate the distance from the lat and lon
		for weather_station in weather_stations
			distance = distance lat, lon, weather_station.lat, weather_station.lon
			# Store this distance in an array of hash maps
			array.push({"weather_station" => weather_stations, "distance" => distance})
		end

		# Sort the array based on distances 
		array = array.sort_by { |k| k["distance"]}
		# Get the 3 closest weather stations to create a triangular encapsulating region
		array.slice! 2

		predictions = {}

		# Put the number of predictions asked for inside the array of hash maps.
		array.each_index do |i|
			weather_station = array[i]["weather_station"]
			array[i]["predictions"] = weather_station.predictions.limit(period/ONE_PERIOD).order('created_at asc')
		end

		# A temperature hash which represents time and temperature prediction
		temperatures= {}
		# A rain hash which represents time and rain prediction
		rain = {}
		# A wind hash which represents the time and wind speed prediction
		wind_speed = {}
		# A wind hash which represents the time and wind direction prediction
		wind_direction = {}

		array[0]["predictions"].each_index do |i|
			# Take the average of 3 predictions 
			prediction_one = array[0]["predictions"][i]
			prediction_two = array[1]["predictions"][i]
			prediction_three = array[2]["predictions"][i]
			avg_temp = (prediction_one.temperature + prediction_two.temperature + prediction_three.temperature)/3
			avg_rain = (prediction_one.rain + prediction_two.rain + prediction_three.rain)/3
			avg_wind_spd = (prediction_one.wind_speed + prediction_two.wind_speed + prediction_three.wind_speed)/3
			avg_wind_dir = (prediction_one.wind_direction + prediction_two.wind_direction + prediction_three.wind_direction)/3
			temperatures["#{i*ONE_PERIOD+ONE_PERIOD}"] = avg_temp
			rain["#{i*ONE_PERIOD+ONE_PERIOD}"] = avg_rain
			wind_speed["#{i*ONE_PERIOD+ONE_PERIOD}"] = avg_wind_spd
			wind_direction["#{i*ONE_PERIOD+ONE_PERIOD}"] = avg_wind_dir
		end
		hash = {}
		hash["temperatures"] = temperatures
		hash["rain"] = rain
		hash["wind_speed"] = wind_speed
		hash["wind_direction"] = wind_direction
		return hash
	end
end
