class Wind < ActiveRecord::Base
	belongs_to :observation

	def as_json(options = nil)


		json_object = { :speed => self.wind_speed, :direction => self.wind_direction }
		if(options != nil)
			json_object.merge(options)
		end

	end

	def self.last_wind_speed

		return Wind.order("created_at").last.wind_speed

	end

	def self.last_wind_direction

		return Wind.order("created_at").last.wind_direction

	end

end
