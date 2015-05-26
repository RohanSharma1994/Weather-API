class RemoveAttributesFromPrediction < ActiveRecord::Migration
  def change
    remove_column :predictions, :rain_probability, :float
    remove_column :predictions, :wind_speed_probability, :float
    remove_column :predictions, :wind_direction_probability, :float
    remove_column :predictions, :temperature_probability, :float
  end
end
