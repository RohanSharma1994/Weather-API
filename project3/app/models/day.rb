# Libraries required
require 'json'

# Represents a day
class Day < ActiveRecord::Base
	# Relationships
	has_many :observations

	# Functions
	# Returns the total rainfall today
	def total_rainfall
		total_rain = 0
		for observation in self.observations
			total_rain += observation.rainfall.rainfall_amount
		end
		return total_rain
	end

	# Gets the latest observation of the day
	def latest_observation
		obs = self.observations.order("created_at").last
		if (obs.created_at >= 30.minutes.ago)
			return obs
		else
			return nil
		end
	end

	# Functions
	# Returns a JSON representation of the weather station
	def as_json options
		observation = self.latest_observation
		if(observation)
			temperature = observation.temperature.current_temperature
			description = observation.description
		else
			description = "null"
			temperature = "null"
		end
		sub_hash = self.observations.to_json
		# Create and return a hash representing this weather station
		{		    
			"date" => "#{self.date.strftime("%d-%m-%Y")}",
		    "current_temp" => "#{temperature}", 
		    "current_cond" => "#{description}", 
		    "measurements" => JSON.parse(self.observations.to_json)
		}
	end


end
