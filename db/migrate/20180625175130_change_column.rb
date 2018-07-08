class ChangeColumn < ActiveRecord::Migration[5.2]
  def change
  	change_column_default :line_items, :quantity, 1
  end
end
