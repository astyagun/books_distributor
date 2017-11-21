class PublisherShopsQuery
  extend SingleForwardable

  delegate call: :new

  def call(publisher)
    PublisherShop.
      includes(shop: {book_shops: :book}).
      where(publisher_shops: {publisher_id: publisher.id}, books: {publisher_id: publisher.id}).
      order('publisher_shops.books_sold_count DESC')
  end
end
