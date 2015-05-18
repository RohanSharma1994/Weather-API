require 'cgi'
require 'date'
class WeatherController < ApplicationController

	def data
		@post_code = params[:post_code]
		@date = params[:date]
		
	end



	def observation_for_post_code()

		#for a post code GET /weather/data/:post_code/:date



	end
	def as_json(options = {})
		options.keys.each { |key| super(key => options[key])}
	end

	def locations
		

		@stations = WeatherStation.all
		date = DateTime.now.to_date
		my_json = {:date => date , :locations => return_formatted_output_for_stations}

		json_ = JSON.pretty_generate(my_json);
       
		respond_to do |format|
			format.html
			format.json { render json: json_ }  #@stations.to_json }
		end

	end
	
	def return_formatted_output_for_stations
		stations = WeatherStation.all.to_a

		#looop on the stations
		required_json_objects = []

		stations.each { |station|
			jo = station.to_json.to_s
			finalObject = jo.gsub!(/\"/, '\'')
			required_json_objects.push(finalObject)
		 }
		return required_json_objects
	end


	def location_retrivel()

	end

	def observation_for_location_id()


	end 
end
