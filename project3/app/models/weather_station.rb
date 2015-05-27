require 'date'
require 'json'

# Represents a weather station
class WeatherStation < ActiveRecord::Base
	# Relationships
	has_many :days
	has_many :predictions

	# Functions
	# Returns a JSON representation of the weather station
	def as_json options
		# Create and return a hash representing this weather station
		{		    
			"id" => "#{self.name}",
		    "lat" => "#{self.lat}", 
		    "lon" => "#{self.lon}", 
		    "last_update" => "#{self.updated_at.strftime('%H:%M%P %d-%m-%Y')}"
		}
	end

	# Returns a JSON representation for the post code API call
	def self.post_code_json weather_stations, date
		final_hash = {"date"=>date, "locations"=>[]}
		for weather_station in weather_stations 
			day = weather_station.days.find_by(date:Date.parse(date))
			if(day)
				observations = day.observations
			else
				observations = nil
			end
			# Create and return a hash representing stations in this post code
			sub_hash = {		    
				"id" => "#{weather_station.name}",
		    	"lat" => "#{weather_station.lat}", 
		    	"lon" => "#{weather_station.lon}", 
		    	"last_update" => "#{weather_station.updated_at.strftime('%H:%M%P %d-%m-%Y')}",
		    	"measurements" => JSON.parse(observations.to_json)
			}
			final_hash["locations"].push sub_hash
		end
		return final_hash
	end
end
