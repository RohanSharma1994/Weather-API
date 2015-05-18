class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :date
      t.references :weather_station
      t.timestamps null: false
    end
    add_foreign_key :weather_stations , :weather_station_id
  end
end
