class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.string :fen
      t.integer :material_count
      t.boolean :pawn_present
      t.boolean :knight_present
      t.boolean :bishop_present
      t.boolean :rook_present
      t.string :queen_present
      t.integer :bookmarks_count

      t.timestamps
    end
  end
end
