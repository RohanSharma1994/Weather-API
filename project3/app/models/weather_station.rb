require 'date'
include Math
class WeatherStation < ActiveRecord::Base
	has_many :days
	has_many :predictions

	def as_json(options = nil)
		hash = {  :id => self.name, :lat => self.lat, :lon => self.lon, :post_code => self.post_code}
		if(options != nil)
				hash = options.merge(hash)
		end
		return hash
	end

	def self.get_location_json
		stations = WeatherStation.all
		JSON.pretty_generate({:date => DateTime.now.to_date, "locations" => JSON.parse((stations.to_json)) })
	end

	def json_for_post_codes date
		json_object = {:id => self.name, :lat => self.lat, :lon => self.lon, :last_update => self.last_update, :measurements => JSON.parse(self.observations.to_json) }
	end

	def self.get_observation_for_location_id location_id, date
		observations = []
		if self.find_by(:name => location_id) != nil
			 days = self.find_by(:name => location_id).days.where(:date => date)
			 if(days.count > 0)
				 	days.each do |day|
					day_observations = day.observations
					if(day_observations.count > 0)
						day_observations.each do |day_observation|
							observations.push(day_observation)
						end
					end
				end
			end
		end
		return observations
	end

	def self.get_json(date, location_id)
		@observations = WeatherStation	.get_observation_for_location_id(location_id, date)
		if(@observations == nil)
			return
		end
		last_observation = Observation.order(:created_at).last
		JSON.pretty_generate({:date => date,
			:current_temp => last_observation.temperature.current_temperature,
			:current_cond => "sunny",
			:measurements =>
				JSON.parse(@observations.to_json) })
	end
end
