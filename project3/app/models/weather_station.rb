require 'date'
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
end
