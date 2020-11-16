class AddPiecesToPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :positions, :pieces, :string
  end
end
