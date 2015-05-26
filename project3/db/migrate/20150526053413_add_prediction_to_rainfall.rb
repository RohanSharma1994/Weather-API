class AddPredictionToRainfall < ActiveRecord::Migration
  def change
    add_reference :rainfalls, :prediction, index: true
    add_foreign_key :rainfalls, :predictions
  end
end
