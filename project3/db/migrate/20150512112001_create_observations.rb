class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :description
      t.float :temperature
      t.float :rain
      t.references :Day
     
    
       t.timestamps null: false
    end
    add_foreign_key :days, :day_id
   
  end
end
