class AddIndexesToOptimizePublisherShopsQuery < ActiveRecord::Migration[5.1]
  def change
    add_index :publisher_shops, :books_sold_count
    add_index :shop_books, :copies_in_stock
  end
end
