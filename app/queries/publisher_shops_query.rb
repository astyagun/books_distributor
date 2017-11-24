class PublisherShopsQuery
  extend SingleForwardable

  delegate call: :new

  def call(publisher_id)
    PublisherShop.
      includes(shop: {shop_books: :book}).
      where(publisher_shops: {publisher_id: publisher_id}, books: {publisher_id: publisher_id}).
      where('shop_books.copies_in_stock > 0').
      order('publisher_shops.books_sold_count DESC, shop_books.copies_in_stock DESC').limit 1000
  end
end
