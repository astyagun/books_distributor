class SellsController < ApplicationController
  rescue_from AmountArgumentError do |exception|
    render(
      json: {'status' => 400, 'detail' => 'Amount parameter has unacceptable value', 'code' => 4001},
      status: 400
    )
  end

  def create
    BookShop.find_by!(shop_id: shop.id, book_id: book.id).increment_copies_sold_by amount
    render json: {status: 200}
  end

  private

  def shop
    Shop.select(:id).find params[:shop_id]
  end

  def book
    Book.select(:id).find params[:book_id]
  end

  # :reek:DuplicateMethodCall
  def amount
    params[:amount].presence && Integer(params[:amount]) || 1
  rescue ArgumentError
    raise AmountArgumentError
  end
end
