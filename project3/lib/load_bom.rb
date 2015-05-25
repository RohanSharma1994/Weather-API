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

	#delete all precious records
	#so get the data less than this date
	days = Day.all.select { |d| d.created_at < DateTime.now }
	if(days != nil && days.count > 0)
		days.each do  |current_day|
			observations = current_day.observations.where(:source => "BOM")
			if(observations != nil && observations.count > 0)
				observations.each do |current_observation|
				    if (current_observation.temperature != nil)
				   		current_observation.temperature.delete
				   	end
				    if(current_observation.wind != nil)
				    	current_observation.wind.delete
				    end

				    if(current_observation.rainfall != nil)
				    	current_observation.rainfall.delete
				    end
	    			current_observation.delete
    			end
    		end
    		current_day.delete
		end
	end

	@stations = WeatherStation.all
	count  = 0
	if(@stations != nil && @stations.count > 0)
		 @stations.each do |station|
		 	if(Time.now.hour - 9 > 0)
		 		time_passed = Time.now.hour - 9
		 	elsif Time.now.hour - 9 == 0
		 		time_passed = 0
	 		else
	 			time_passed = (9 - time).abs +  (24 - Time.now.hour).abs
	 		end
			if(date_time.to_a[count] != nil)
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
				wind_created = 	Wind.create(wind_speed: speed, wind_direction: direction)
				o.wind  = wind_created
				temperature_created = Temperature.create(:current_temperature => t)
				o.temperature = temperature_created
				rainfall_created = Rainfall.create(:rainfall_amount => rain)
				o.rainfall = rainfall_created
				puts o.id
				count += 1
			end
		end
	end
#day has station id
#observation has day id

#we create a day
=begin



=end
