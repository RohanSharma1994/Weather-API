class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.float :variance
      t.float :probability
      t.time :time
    
      t.references :Day
      t.timestamps null: false
    end
    add_foreign_key :days, :day_id
  
  end
end
