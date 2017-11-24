require 'rails_helper'

RSpec.describe 'Publisher shops', type: :request do
  describe 'GET /publishers/:publisher_id/shops' do
    subject :parsed_response do
      get publisher_shops_path publisher
      JSON.parse response.body
    end

    context 'when DB has data' do
      let!(:publisher) { create :publisher }
      let!(:shop1) { create :shop }
      let!(:shop2) { create :shop }
      let!(:book1) { create :book, publisher: publisher }
      let!(:book2) { create :book, publisher: publisher }
      let!(:shop_book1) { create :shop_book, shop: shop1, book: book1, copies_sold: 42 }
      let!(:shop_book2) { create :shop_book, shop: shop1, book: book2, copies_sold: 100500 }
      let!(:shop_book3) { create :shop_book, shop: shop2, book: book1, copies_sold: 100543 }

      it 'renders shops, that sell books of a publisher', :aggregate_failures do
        expect(parsed_response).to eq(
          'status' => 200,
          'shops'  => [
            {
              'id'               => shop2.id,
              'name'             => shop2.name,
              'books_sold_count' => shop_book3.copies_sold,
              'books'            => [
                {
                  'id'              => book1.id,
                  'title'           => book1.title,
                  'copies_in_stock' => shop_book3.copies_in_stock
                }
              ]
            },
            {
              'id'               => shop1.id,
              'name'             => shop1.name,
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
            }
          ]
        )
        expect(response).to have_http_status :success
      end
    end

    context 'when there is no publisher for a given publisher_id parameter' do
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
