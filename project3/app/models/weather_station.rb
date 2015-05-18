class WeatherStation < ActiveRecord::Base
	has_many :days
	#self.primary_key = 'id'
end
