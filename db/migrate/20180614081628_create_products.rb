class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.string :brand
      t.string :model
      t.float :price
      t.integer :quantity
      t.float :weight
      t.text :description
      t.timestamps
    end
  end
end
