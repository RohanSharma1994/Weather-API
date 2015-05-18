class AddObservationToRainfall < ActiveRecord::Migration
  def change
    add_reference :rainfalls, :observation, index: true
    add_foreign_key :rainfalls, :observations
  end
end
