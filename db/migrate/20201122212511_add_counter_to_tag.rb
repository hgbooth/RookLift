class AddCounterToTag < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :bookmarks_count, :integer
  end
end
