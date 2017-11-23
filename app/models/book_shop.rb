class BookShop < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  after_commit :update_publisher_shop, on: %i[create update destroy]

  def increment_copies_sold_by(amount)
    self.class.unscoped.
      where(self.class.primary_key => id).
      update_all(['copies_sold = copies_sold + ?', amount])
    touch
  rescue ActiveRecord::StatementInvalid
    raise AmountArgumentError
  end

  def update_publisher_shop
    PublisherShop.find_or_create_by(publisher: book.publisher, shop: shop).update_books_sold_count
  end
end
