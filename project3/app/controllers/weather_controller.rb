require 'cgi'
require 'date'
class WeatherController < ApplicationController

	def data
		@post_code = params[:post_code]
		if(@post_code[/[0-9]/] == nil)
			@message = "please DONT give me a shit post code"
		end
	end



	def observation_for_post_code()

		#for a post code GET /weather/data/:post_code/:date



	end
	def to_json
		ActiveRecord::JSON.decode(super).merge({ :date => DateTime.now.to_date}).to_json
	end

	def locations
		#this is just getting the all 

		@stations = WeatherStation.all

		respond_to do |format|
			format.html
			format.json { render json: @stations.to_json }
		end

	end
	


	def location_retrivel()

	end

	def observation_for_location_id()


	end 
end
