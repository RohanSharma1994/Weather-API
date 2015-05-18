class AddSourceToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :source, :string
  end
end
