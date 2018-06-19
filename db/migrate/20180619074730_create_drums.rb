class CreateDrums < ActiveRecord::Migration[5.2]
  def change
    create_table :drums do |t|
      t.integer :pedals
      t.string :color
      t.integer :cymbals
      t.integer :toms
      t.timestamps
    end
  end
end
