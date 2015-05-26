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
end
