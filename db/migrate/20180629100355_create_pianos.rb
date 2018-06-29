class CreatePianos < ActiveRecord::Migration[5.2]
  def change
    create_table :pianos do |t|
      t.string :tipo
      t.string :color
      t.string :material
      t.string :n_key
    end
  end
end
