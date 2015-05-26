class Prediction < ActiveRecord::Base
	# Relationships
	belongs_to :weather_station
	has_one :rainfall
	has_one :temperature
	has_one :wind
end
