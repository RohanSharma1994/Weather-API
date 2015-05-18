require 'nokogiri'
require 'open-uri'
require 'json'
require 'date'

url = 'http://www.bom.gov.au/vic/observations/melbourne.shtml'
	doc = Nokogiri::HTML(open(url))
	temp  = doc.css('[headers~=obs-temp]')
	date_time =  doc.css('[headers~=obs-datetime]')
	wind_speed =  doc.css('[headers~=obs-wind-spd-kph]')
	wind_direction =  doc.css('[headers~=obs-wind-dir]')
	rainfall =  doc.css('[headers~=obs-rainsince9am]')
	dew_point =  doc.css('[headers~=obs-dewpoint]')

	@station = WeatherStation.all.to_a
	count  = 0

	 @station.each do |station|
	 	if(Time.now.hour - 9 > 0)
	 		time_passed = Time.now.hour - 9
	 	elsif Time.now.hour - 9 == 0
	 		time_passed = 0
 		else
 			time_passed = (9 - time).abs +  (24 - Time.now.hour).abs 
 		end
		date = Date.parse(date_time.to_a[count].text)
		
		speed = wind_speed[count].text.to_f
		direction = wind_direction[count].text
		if(time_passed != 0)
			rain = (rainfall[count].text.to_f/ time_passed).round(4)
		else
			rain  = (rainfall[count].text.to_f).round(4)
		end
		day_created = station.days.create(:date => date)
		dp = dew_point[count].text.to_f
		t = temp[count].text.to_f
		o = day_created.observations.create(source: "BOM", description: "not sure")
		count += 1
	end 
#day has station id 
#observation has day id

#we create a day 
=begin


o.wind_observations.create(wind_speed: speed, wind_direction: direction)
=end
