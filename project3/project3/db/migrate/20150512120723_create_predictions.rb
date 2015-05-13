class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.float :variance
      t.float :probability
      t.time :time
      t.references :WindObservation
      t.references :RainfallObservation
      t.references :TemperatureObservation
      t.references :Day
      t.timestamps null: false
    end
    add_foreign_key :days, :day_id
    add_foreign_key :rainfall_observations, :rainfall_observation_id
    add_foreign_key :temperature_observations, :temperature_observation_id
    add_foreign_key :wind_observations, :wind_observation_id
    add_foreign_key :days, :day_id
  end
end
