class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
