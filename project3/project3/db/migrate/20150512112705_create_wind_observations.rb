class CreateWindObservations < ActiveRecord::Migration
  def change
    create_table :wind_observations do |t|
      t.float :wind_speed
      t.float :wind_direction
      t.references :Observation
      t.references :Prediction
      t.timestamps null: false
    end
    add_foreign_key :observations, :observation_id
    add_foreign_key :predictions, :prediction_id
  end
end
