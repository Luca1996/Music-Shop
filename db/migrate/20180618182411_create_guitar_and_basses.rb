class CreateGuitarAndBasses < ActiveRecord::Migration[5.2]
  def change
    create_table :guitar_and_basses do |t|
      t.string :hand
      t.string :color
      t.string :material
      t.integer :chords
      t.boolean :digital
      t.timestamps
    end
  end
end
