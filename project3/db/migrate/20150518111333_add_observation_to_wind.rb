class AddObservationToWind < ActiveRecord::Migration
  def change
    add_reference :winds, :observation, index: true
    add_foreign_key :winds, :observations
  end
end
