class AddPredictionToTemperature < ActiveRecord::Migration
  def change
    add_reference :temperatures, :prediction, index: true
    add_foreign_key :temperatures, :predictions
  end
end
