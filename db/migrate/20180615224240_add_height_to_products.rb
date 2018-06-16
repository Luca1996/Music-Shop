class AddHeightToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :height, :integer
  end
end
