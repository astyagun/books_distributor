require 'rails_helper'

RSpec.describe 'Publisher shops', type: :request do
  describe 'GET /publishers/:publisher_id/shops' do
    subject :parsed_response do
      get publisher_shops_path publisher
      JSON.parse response.body
    end

    let!(:publisher) { create :publisher }
    let!(:book1) { create :book, publisher: publisher }
    let!(:book2) { create :book, publisher: publisher }
    let!(:shop) { create :shop }
    let!(:book_shop1) { create :book_shop, book: book1, shop: shop }
    let!(:book_shop2) { create :book_shop, book: book2, shop: shop }

    it 'renders shops, that sell books of a publisher', :aggregate_failures do
      expect(parsed_response).to eq(
        'shops' => [
          'id'               => shop.id,
          'name'             => shop.name,
          'books_sold_count' => book_shop1.copies_sold + book_shop2.copies_sold,
          'books'            => [
            {
              'id'              => book1.id,
              'title'           => book1.title,
              'copies_in_stock' => book_shop1.copies_in_stock
            },
            {
              'id'              => book2.id,
              'title'           => book2.title,
              'copies_in_stock' => book_shop2.copies_in_stock
            }
          ]
        ]
      )
      expect(response).to have_http_status 200
    end
  end
end
