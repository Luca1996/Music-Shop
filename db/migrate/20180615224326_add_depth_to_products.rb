class AddDepthToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :depth, :integer
  end
end
