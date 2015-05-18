class AddDayToObservation < ActiveRecord::Migration
  def change
    add_reference :observations, :day, index: true
    add_foreign_key :observations, :days
  end
end
