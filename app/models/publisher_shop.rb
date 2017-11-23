class PublisherShop < ApplicationRecord
  belongs_to :publisher
  belongs_to :shop

  def update_book_counts
    update_attributes calculate_book_counts_attributes
  end

  private

  def calculate_book_counts_attributes
    query_result = book_counts_calculation_query

    if query_result.empty?
      {books_sold_count: 0, books_in_stock_count: 0}
    else
      query_result.to_a.first.slice(:books_sold_count, :books_in_stock_count)
    end
  end

  def book_counts_calculation_query
    ShopBook.
      joins(:book).
      where(shop_id: shop_id, books: {publisher_id: publisher_id}).
      group('books.publisher_id, shop_books.shop_id').
      select('SUM(shop_books.copies_sold) AS books_sold_count').
      select('SUM(shop_books.copies_in_stock) AS books_in_stock_count')
  end
end
