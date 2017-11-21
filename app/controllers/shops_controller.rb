class ShopsController < ApplicationController
  def index
    @publisher_shops = PublisherShopsQuery.call publisher
  end

  private

  def publisher
    Publisher.find params[:publisher_id]
  end
end
