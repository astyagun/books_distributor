class CreateBookShops < ActiveRecord::Migration[5.1]
  def change
    create_table :book_shops do |t|
      t.belongs_to :book
      t.belongs_to :shop
      t.integer :copies_in_stock, null: false, default: 0
      t.integer :copies_sold,     null: false, default: 0

      t.timestamps
    end
  end
end
