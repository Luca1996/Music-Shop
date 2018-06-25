class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      # note : when searching the line_items which belong to a cart
      # it will be faster, cause i added an index on cart
      t.references :cart, foreign_key: true
      # note : when searching the line_items whose product referred is
      # known, it will take less cause i added an index on product
      t.references :product, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
