class RenameGuitarBassToGuitar < ActiveRecord::Migration[5.2]
  def change
    rename_table :guitar_and_basses, :guitars
  end
end
