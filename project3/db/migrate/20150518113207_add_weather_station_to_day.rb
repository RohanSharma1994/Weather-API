class AddWeatherStationToDay < ActiveRecord::Migration
  def change
    add_reference :days, :weather_station, index: true
    add_foreign_key :days, :weather_stations
  end
end
