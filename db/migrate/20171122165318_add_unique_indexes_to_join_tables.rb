class AddUniqueIndexesToJoinTables < ActiveRecord::Migration[5.1]
  def change
    add_index :publisher_shops, [:publisher_id, :shop_id], unique: true
    add_index :book_shops, [:book_id, :shop_id], unique: true
  end
end
