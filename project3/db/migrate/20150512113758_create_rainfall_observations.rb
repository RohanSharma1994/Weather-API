class CreateRainfallObservations < ActiveRecord::Migration
  def change
    create_table :rainfall_observations do |t|
      t.float :rainfall_amount
      t.references :Observation
      t.references :Prediction
      t.timestamps null: false
    end
    add_foreign_key :observations, :observation_id
    add_foreign_key :predictions, :prediction_id
  end
end
