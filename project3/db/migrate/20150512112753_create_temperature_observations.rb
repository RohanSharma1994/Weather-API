class CreateTemperatureObservations < ActiveRecord::Migration
  def change
    create_table :temperature_observations do |t|
      t.float :current_temperature
      t.references :Observation
      t.references :Prediction
      t.timestamps null: false
    end
    add_foreign_key :observations, :observation_id
    add_foreign_key :predictions, :prediction_id
  end
end
