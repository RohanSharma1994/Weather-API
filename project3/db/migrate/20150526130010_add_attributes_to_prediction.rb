class AddAttributesToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :temperature_variance, :float
    add_column :predictions, :wind_speed_variance, :float
    add_column :predictions, :wind_direction_variance, :float
    add_column :predictions, :rain_variance, :float
  end
end
