# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
WeatherStation.create(:name => "CHARLTON", :lat => -36.28,  :lon => 143.33, post_code: "3525")
WeatherStation.create(:name => "HOPETOUN AIRPORT", :lat => -35.72,  :lon => 142.36, post_code: "3340")

WeatherStation.create(:name => "MILDURA AIRPORT", :lat => -34.24,  :lon => 142.09, post_code: "3500")
