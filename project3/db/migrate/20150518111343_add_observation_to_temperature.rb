class AddObservationToTemperature < ActiveRecord::Migration
  def change
    add_reference :temperatures, :observation, index: true
    add_foreign_key :temperatures, :observations
  end
end
