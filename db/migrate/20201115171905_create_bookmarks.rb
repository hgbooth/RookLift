class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.integer :position_id
      t.integer :user_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
