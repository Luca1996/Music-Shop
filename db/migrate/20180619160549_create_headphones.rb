class CreateHeadphones < ActiveRecord::Migration[5.2]
  def change
    create_table :headphones do |t|
      t.boolean :wireless
      t.boolean :bluetooth
      t.float :cable_length
      t.float :impedence
      t.string :type
      t.timestamps
    end
  end
end
