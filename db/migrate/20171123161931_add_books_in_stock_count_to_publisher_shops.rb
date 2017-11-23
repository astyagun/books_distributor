class AddBooksInStockCountToPublisherShops < ActiveRecord::Migration[5.1]
  def change
    add_column :publisher_shops, :books_in_stock_count, :integer, null: false, default: 0
  end
end
