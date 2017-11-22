class ShopsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    render json: {status: 404, detail: 'Record not found'}, status: :not_found
  end

  def index
    @publisher_shops = PublisherShopsQuery.call publisher.id
  end

  private

  def publisher
    Publisher.select(:id).find params[:publisher_id]
  end
end
