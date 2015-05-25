require 'cgi'
require 'date'
require 'time'


class WeatherController < ApplicationController
	def data_per_id
		#here we are getting location id and date
		@location_id = params[:location_id]
		begin
			@date = DateTime.parse(params[:date]).to_date
		rescue  ArgumentError
			@error = "Date format is incorrect"
			return
		end
		if(@location_id.to_i != 0)
			#data_per_post_code @location_id, @date
			@stations = WeatherStation.all
			#need to filter stations according to post code
			#as well observations
			json_to_render = {:date => @date,:locations=> JSON.parse(@stations.to_json(:observations => JSON.parse(Observation.all.to_json)))}
			respond_to do |format|
				format.json { render json: JSON.pretty_generate(json_to_render)}
			end
		else
			json_to_render = WeatherStation.get_json(@date,@location_id)
			respond_to do |format|
				format.html
				format.json {render json: (json_to_render) }
			end
		end
	end
	def locations
		json_to_render = WeatherStation.get_location_json
		respond_to do |format|
			format.html
			format.json { render json: json_to_render }
		end
	end
end
