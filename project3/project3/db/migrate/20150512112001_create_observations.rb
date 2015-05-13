class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :description
      t.float :temperature
      t.float :rain
      t.references :Day
     
      t.references :WindObservation
      t.references :RainfallObservation
      t.references :TemperatureObservation

       t.timestamps null: false
    end
    add_foreign_key :days, :day_id
    add_foreign_key :rainfall_observations, :rainfall_observation_id
    add_foreign_key :temperature_observations, :temperature_observation_id
    add_foreign_key :wind_observations, :wind_observation_id
  end
end
