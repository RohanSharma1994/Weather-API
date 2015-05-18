class Day < ActiveRecord::Base
	belongs_to :weather_station
	has_many :observations
end
