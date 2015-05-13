require 'cgi'
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

	def location_retrivel()

	end

	def observation_for_location_id()


	end 
end
