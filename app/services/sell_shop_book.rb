class SellShopBook
  extend SingleForwardable

  delegate call: :new

  # :reek:FeatureEnvy
  # rubocop:disable Rails/SkipsModelValidations
  def call(shop_book, amount)
    ShopBook.unscoped.
      where(ShopBook.primary_key => shop_book.id).
      update_all([
        'copies_sold = copies_sold + :amount, copies_in_stock = copies_in_stock - :amount',
        {amount: amount}
      ])
    shop_book.touch
  rescue ActiveRecord::StatementInvalid
    raise AmountArgumentError
  end
  # rubocop:enable Rails/SkipsModelValidations
end
