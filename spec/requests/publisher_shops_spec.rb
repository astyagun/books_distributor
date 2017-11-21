require 'rails_helper'

RSpec.describe 'Publisher shops', type: :request do
  describe 'GET /publishers/:id/shops' do
    subject :parsed_response do
      get publisher_shops_path publisher
      JSON.parse response.body
    end

    let!(:publisher) { create :publisher }
    let!(:book) { create :book, publisher: publisher }
    let!(:shop) { create :shop }
    let!(:book_shop) { create :book_shop, book: book, shop: shop }
    let!(:publisher_shop) { create :publisher_shop, publisher: publisher, shop: shop }

    it 'returns HTTP 200 code' do
      parsed_response
      expect(response).to have_http_status 200
    end

    it 'renders shops, that sell books of a publisher' do
      expect(parsed_response).to eq(
        'shops' => [
          'id'               => shop.id,
          'name'             => shop.name,
          'books_sold_count' => publisher_shop.books_sold_count,
          'books'            => [
            {
              'id'              => book.id,
              'title'           => book.title,
              'copies_in_stock' => book_shop.copies_in_stock
            }
          ]
        ]
      )
    end

    it 'renders books_sold_count when books are scattered across shops and publishers'
    it 'does not render shops, that sell only books of other publishers'
    it 'orders something by something'
  end
end
