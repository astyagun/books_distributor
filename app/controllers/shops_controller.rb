class ShopsController < ApplicationController
  def index
    @publisher_shops = PublisherShopsQuery.call publisher.id
  end

  private

  def publisher
    Publisher.select(:id).find params[:publisher_id]
  end
end
