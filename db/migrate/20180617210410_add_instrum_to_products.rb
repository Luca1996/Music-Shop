class AddInstrumToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :instrum, polymorphic: true, index:true
  end
end
