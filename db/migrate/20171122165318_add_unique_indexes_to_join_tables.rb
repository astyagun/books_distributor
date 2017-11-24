class AddUniqueIndexesToJoinTables < ActiveRecord::Migration[5.1]
  def change
    add_index :publisher_shops, %i[publisher_id shop_id], unique: true
    add_index :shop_books, %i[shop_id book_id], unique: true
  end
end
