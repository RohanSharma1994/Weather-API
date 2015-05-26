class AddPredictionToWind < ActiveRecord::Migration
  def change
    add_reference :winds, :prediction, index: true
    add_foreign_key :winds, :predictions
  end
end
