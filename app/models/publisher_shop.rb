class PublisherShop < ApplicationRecord
  belongs_to :publisher
  belongs_to :shop

  def update_books_sold_count
    update_attributes books_sold_count: BookShop.
      joins(:book).
      where(books: {publisher_id: publisher_id}, shop_id: shop_id).
      group('books.publisher_id, book_shops.shop_id').
      pluck('SUM(book_shops.copies_sold)').
      first || 0
  end
end
