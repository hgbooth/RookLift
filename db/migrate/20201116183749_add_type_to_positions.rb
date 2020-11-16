class AddTypeToPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :positions, :endgame_type, :string
  end
end
