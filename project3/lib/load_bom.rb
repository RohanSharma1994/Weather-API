# This script scrapes weather data in the background
# Libraries required
require 'nokogiri'
require 'open-uri'
require_relative 'persist_functions.rb'
require_relative 'prediction.rb'

url = 'http://www.bom.gov.au/vic/observations/vicall.shtml'
doc = Nokogiri::HTML(open(url))
# Array of table IDS to scrape data from the BOM website
table_ids = ['tMAL', 'tWIM', 'tSW', 'tCEN', 'tNCY', 'tNE', 'tNC', 'tWSG', 'tEG', 'tMOB']
# Used to normalize wind directions (Credit to Project 2 sample solution)
WIND_DIRS = %i{ N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW }.freeze
WIND_DIR_MAPPINGS = WIND_DIRS.each_with_index.inject({}) { |m, (dir, index)| m[dir] = index * 360.0 / WIND_DIRS.size; m }.freeze
SOURCEBOM = "BOM"
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
		temperature = row.css('[headers~='+table_id+'-tmp]').text
		wind_speed = row.css('[headers~='+table_id+'-wind-spd-kmh]').text
		wind_direction = row.css('[headers~='+table_id+'-wind-dir]').text
		# Normalize wind direction
		wind_direction = WIND_DIR_MAPPINGS[wind_direction.to_sym].to_f
		rain = row.css('[headers~='+table_id+'-rainsince9am]').text
		# Normalize rain to mm/10 minutes since we make an observation every 10 minutes
		rain = convert_to_intensity name, rain
		# Persist this data
		persist_data name, SOURCEBOM, temperature,  wind_speed, wind_direction, rain
	end
end
# Make predictions
make_prediction
end