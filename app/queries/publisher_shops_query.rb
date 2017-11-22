class PublisherShopsQuery
  extend SingleForwardable

  delegate call: :new

  def call(publisher_id)
    PublisherShop.
      includes(shop: {book_shops: :book}).
      where(publisher_shops: {publisher_id: publisher_id}, books: {publisher_id: publisher_id}).
      order('publisher_shops.books_sold_count DESC')
  end
end
