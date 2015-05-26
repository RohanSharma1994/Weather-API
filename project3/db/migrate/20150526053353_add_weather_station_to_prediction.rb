class AddWeatherStationToPrediction < ActiveRecord::Migration
  def change
    add_reference :predictions, :weather_station, index: true
    add_foreign_key :predictions, :weather_stations
  end
end
