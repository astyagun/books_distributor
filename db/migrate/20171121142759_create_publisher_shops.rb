class CreatePublisherShops < ActiveRecord::Migration[5.1]
  def change
    create_table :publisher_shops do |t|
      t.belongs_to :publisher, foreign_key: true
      t.belongs_to :shop,      foreign_key: true
      t.integer :books_sold_count, null: false, default: 0

      t.timestamps
    end
  end
end
