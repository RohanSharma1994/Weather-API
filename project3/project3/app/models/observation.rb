class Observation < ActiveRecord::Base
	belongs_to :day
	belongs_to :wind_observation
	belongs_to :rainfall_observation
	belongs_to :temperature_observation
end
