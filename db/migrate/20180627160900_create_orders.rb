class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :address
      t.string :t_num
      t.integer :p_method
      t.timestamps
    end
  end
end
