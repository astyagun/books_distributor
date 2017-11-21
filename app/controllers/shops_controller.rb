class ShopsController < ApplicationController
  def index
    # TODO: Optimize query
    @publisher_shops = PublisherShop.all
  end
end
