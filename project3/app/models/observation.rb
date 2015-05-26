class Observation < ActiveRecord::Base
	belongs_to :day
	has_one :wind
	has_one :rainfall
	has_one :temperature

	# Functions
	# Returns a JSON representation of the observation
	def as_json options
		# Create and return a hash representing this weather station
		{		    
			"time" => "#{self.created_at.strftime('%I:%M:%S %P')}",
		    "temp" => "#{self.temperature.current_temperature}", 
		    "precip" => "#{self.rainfall.rainfall_amount}" + "mm", 
		    "wind_direction" => "#{self.wind.wind_direction}",
		    "wind_speed" => "#{self.wind.wind_speed}"
		}
	end
end
