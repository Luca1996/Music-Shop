class CreateOthers < ActiveRecord::Migration[5.2]
  def change
    create_table :others do |t|
      t.string :tipo
      t.timestamps
    end
  end
end
