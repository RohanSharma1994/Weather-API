# This script scrapes weather data in the background
# Libraries required
require 'nokogiri'
require 'open-uri'
require_relative 'persist_functions.rb'
require_relative 'prediction.rb'

# Used to normalize wind directions (Credit to Project 2 sample solution)
WIND_DIRS = %i{ N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW }.freeze
WIND_DIR_MAPPINGS = WIND_DIRS.each_with_index.inject({}) { |m, (dir, index)| m[dir] = index * 360.0 / WIND_DIRS.size; m }.freeze
SOURCEBOM = "BOM"

# Checks if string is a number.
# If it is returns the float value of it
# Otherwise returns nil
def numeric string
    Float(string) rescue nil
end

# predictions: The amount of predictions to make in the future after loading the data.
def load_data predictions
	url = 'http://www.bom.gov.au/vic/observations/vicall.shtml'
	doc = Nokogiri::HTML(open(url))
	# Array of table IDS to scrape data from the BOM website
	table_ids = ['tMAL', 'tWIM', 'tSW', 'tCEN', 'tNCY', 'tNE', 'tNC', 'tWSG', 'tEG', 'tMOB']
	ActiveRecord::Base.transaction do
		for table_id in table_ids
			# Select the appropriate table 
			table = doc.css('#'+table_id)
			# Select the table body
			body = table.css('tbody')
			# Select the rows of data in the table
			rows = body.css('tr')
			for row in rows
				# Extract the data from this row
				name = row.css('th').text
				puts "Attempting to scrape data for #{name}..."
				temperature = row.css('[headers~='+table_id+'-tmp]').text
				wind_speed = row.css('[headers~='+table_id+'-wind-spd-kmh]').text
				wind_direction = row.css('[headers~='+table_id+'-wind-dir]').text
				# Normalize wind direction
				wind_direction = WIND_DIR_MAPPINGS[wind_direction.to_sym].to_f
				rain = row.css('[headers~='+table_id+'-rainsince9am]').text
				puts "Temperature:#{temperature}, WindSpeed:#{wind_speed}, WindDir:#{wind_direction}, Rain:#{rain}"
				# If this weather station isn't recorded remove it from DB
				if not numeric temperature
					weather_station = WeatherStation.find_by(name:name)
					if weather_station
						weather_station.destroy
					end
					puts "Destroyed #{name}..."
				end
				# Normalize rain to mm/10 minutes since we make an observation every 10 minutes
				rain = convert_to_intensity name, rain
				# Persist this data
				persist_data name, SOURCEBOM, temperature,  wind_speed, wind_direction, rain
			end
		end
		# Make predictions
		make_prediction predictions
	end
end