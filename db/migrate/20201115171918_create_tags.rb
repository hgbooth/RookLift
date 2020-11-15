class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.integer :bookmark_id
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
