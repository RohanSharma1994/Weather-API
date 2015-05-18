class Observation < ActiveRecord::Base
	belongs_to :day
	has_one :wind
	has_one :rainfall
	has_one :temperature
end
