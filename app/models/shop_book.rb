class ShopBook < ApplicationRecord
  belongs_to :shop
  belongs_to :book

  after_commit :update_publisher_shop, on: %i[create update destroy]

  def update_publisher_shop
    PublisherShop.find_or_create_by(publisher: book.publisher, shop: shop).update_books_sold_count
  end
end
