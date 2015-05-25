class Observation < ActiveRecord::Base
	belongs_to :day
	has_one :wind
	has_one :rainfall
	has_one :temperature

	def as_json(options= {})
		json_object = {:time => Observation.last_updated_time,
		:temp => Observation.last_updated_temp.current_temperature, :precp => Observation.last_updated_rainfall.rainfall_amount, :wind_direction => Observation.last_updated_wind.wind_direction, :wind_speed => Observation.last_updated_wind.wind_speed}
		json_object.merge(options)
		return json_object
	end

	def self.last_updated_time
			return Observation.order(:created_at).last.created_at.strftime("%H:%M")
	end
	def self.last_updated_temp
		return Observation.order(:created_at).last.temperature
	end
	def self.last_updated_rainfall
		return Observation.order(:created_at).last.rainfall
	end
	def self.last_updated_wind
		return  Observation.order(:created_at).last.wind
	end
	def current_cond

		#get the curent temperature
		#get the curent rainfall
		#get the wind

		#relate them and see if the rainfall amount is not 0 and wind speed is also greater than 0 and temperature is reasonable than that means cloudy,
		#temperature is low and rainfall amount is siginficant rainy and if there are wind coming then rainy and windy


	end





end
