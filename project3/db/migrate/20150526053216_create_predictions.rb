class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.time :time
      t.float :rain_probability
      t.float :wind_speed_probability
      t.float :wind_direction_probability
      t.float :temperature_probability

      t.timestamps null: false
    end
  end
end
