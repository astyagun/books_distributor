require 'rails_helper'

RSpec.describe 'Publisher shops', type: :request do
  describe 'GET /publishers/:publisher_id/shops' do
    subject :parsed_response do
      get publisher_shops_path publisher
      JSON.parse response.body
    end

    context 'when DB has data' do
      let!(:publisher) { create :publisher }
      let!(:book1) { create :book, publisher: publisher }
      let!(:book2) { create :book, publisher: publisher }
      let!(:shop) { create :shop }
      let!(:book_shop1) { create :book_shop, book: book1, shop: shop }
      let!(:book_shop2) { create :book_shop, book: book2, shop: shop }

      it 'renders shops, that sell books of a publisher', :aggregate_failures do
        expect(parsed_response).to eq(
          'status' => 200,
          'shops'  => [
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
        expect(response).to have_http_status :success
      end
    end

    context 'when publisher_id parameter does not have corresponding publisher in DB' do
      let(:publisher) { 123_456 }

      it 'returns error message', :aggregate_failures do
        expect(parsed_response).to eq(
          'status' => 404,
          'detail' => 'Record not found'
        )
        expect(response).to have_http_status :not_found
      end
    end
  end
end
