class PublisherShop < ApplicationRecord
  belongs_to :publisher
  belongs_to :shop

  def update_books_sold_count
    update books_sold_count: query_books_sold_count
  end

  private

  def query_books_sold_count
    ShopBook
      .joins(:book)
      .where(shop_id: shop_id, books: {publisher_id: publisher_id})
      .group('books.publisher_id, shop_books.shop_id')
      .pluck('SUM(shop_books.copies_sold)')
      .first || 0
  end
end
