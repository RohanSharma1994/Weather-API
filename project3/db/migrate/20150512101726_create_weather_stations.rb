class CreateWeatherStations < ActiveRecord::Migration
  def change
    create_table :weather_stations do |t|
      t.float :lat
      t.float :lon
      t.string :post_code
      t.string :name, null: false

      t.timestamps null: false

    end
   
  end


end
#id: false 
# add_index :weather_stations, :id, unique: true