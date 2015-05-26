class RemoveWindDirectionFromWind < ActiveRecord::Migration
  def change
    remove_column :winds, :wind_direction, :string
  end
end
