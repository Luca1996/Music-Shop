class CreateGuitarAndBasses < ActiveRecord::Migration[5.2]
  def change
    create_table :guitars do |t|
      t.string :hand
      t.string :color
      t.string :material
      t.integer :chords
      t.boolean :digital
      t.timestamps
    end
  end
end
