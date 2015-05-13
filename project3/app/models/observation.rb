class Observation < ActiveRecord::Base
	belongs_to :day
	has_one :wind_observation
	has_one :rainfall_observation
	has_one :temperature_observation
end
