class CreateHeadphones < ActiveRecord::Migration[5.2]
  def change
    create_table :headphones do |t|
      t.boolean :wireless
      t.boolean :bluetooth
      t.float :cable_length
      t.integer :impedence
      t.string :h_type
      t.timestamps
    end
  end
end
