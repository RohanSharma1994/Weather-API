class AddWindDirectionToWind < ActiveRecord::Migration
  def change
    add_column :winds, :wind_direction, :float
  end
end
