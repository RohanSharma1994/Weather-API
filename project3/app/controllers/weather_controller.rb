require 'date'
require 'time'

# The data retrieval controller
class WeatherController < ApplicationController
	# Action which shows all the locations inside the database.
	# Responds to the request: GET '/weather/locations'
	def locations
		@weather_stations = WeatherStation.all
		# A JSON hash to respond with
		hash = {"date"=>Date.today.strftime("%d-%m-%Y"), "locations"=>JSON.parse(@weather_stations.to_json)}
		respond_to do |format|
			format.html
			format.json { render json: JSON.pretty_generate(hash)}
		end
	end


	# Action which shows all the data given a locationID and a date/
	# Responds to the request: weather/data/:location_id/:date
	def data_per_location_id
		# Find the appropriate weather station
		@weather_station = WeatherStation.find_by(name:params[:location_id])
		# Find the appropriate date
		if @weather_station
			@day = @weather_station.days.find_by(date: Date.parse(params[:date]))
		end
		# A JSON hash to respond with
		if @day
			hash = JSON.parse(@day.to_json)
		else
			hash = {}
		end
		respond_to do |format|
			format.html
			format.json { render json: JSON.pretty_generate(hash)}
		end
	end

	# Action which shows all the data for a weather station in a
	# given post code on a given date.
	# Responds to the request: weather/data/:post_code/:date
	def data_per_post_code

	end

end
