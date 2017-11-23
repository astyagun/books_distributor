require 'rails_helper'

RSpec.describe 'Publisher shops', type: :request do
  describe 'GET /publishers/:publisher_id/shops' do
    subject :parsed_response do
      get publisher_shops_path publisher
      JSON.parse response.body
    end

    context 'when DB has data' do
      let!(:publisher) { create :publisher }
      let!(:shop) { create :shop }
      let!(:book1) { create :book, publisher: publisher }
      let!(:book2) { create :book, publisher: publisher }
      let!(:shop_book1) { create :shop_book, shop: shop, book: book1, copies_sold: 42 }
      let!(:shop_book2) { create :shop_book, shop: shop, book: book2, copies_sold: 100500 }

      it 'renders shops, that sell books of a publisher', :aggregate_failures do
        expect(parsed_response).to eq(
          'status' => 200,
          'shops'  => [
            'id'               => shop.id,
            'name'             => shop.name,
            'books_sold_count' => shop_book1.copies_sold + shop_book2.copies_sold,
            'books'            => [
              {
                'id'              => book2.id,
                'title'           => book2.title,
                'copies_in_stock' => shop_book2.copies_in_stock
              },
              {
                'id'              => book1.id,
                'title'           => book1.title,
                'copies_in_stock' => shop_book1.copies_in_stock
              }
            ]
          ]
        )
        expect(response).to have_http_status :success
      end
    end

    context 'when publisher_id parameter does not have corresponding publisher in DB' do
      let(:publisher) { 123_456 }

      it 'returns error', :aggregate_failures do
        expect(parsed_response).to eq(
          'status' => 404,
          'detail' => 'Record not found'
        )
        expect(response).to have_http_status :not_found
      end
    end
  end
end
