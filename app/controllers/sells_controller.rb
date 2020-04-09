class SellsController < ApplicationController
  rescue_from AmountArgumentError do
    render(
      json:   {
        'status' => 400,
        'detail' => 'Amount parameter has an unacceptable value, must be an integer',
        'code'   => 4001
      },
      status: 400
    )
  end

  def create
    SellShopBook.call(
      ShopBook.find_by!(shop_id: params[:shop_id], book_id: params[:book_id]),
      amount
    )
    render json: {status: 200}
  end

  private

  # :reek:DuplicateMethodCall
  def amount
    params[:amount].presence && Integer(params[:amount]) || 1
  rescue ArgumentError
    raise AmountArgumentError
  end
end
