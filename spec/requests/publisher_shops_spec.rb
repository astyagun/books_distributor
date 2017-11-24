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
      let!(:shop3) { create :shop }
      let!(:book1) { create :book, publisher: publisher }
      let!(:book2) { create :book, publisher: publisher }
      let! :shop_book1 do
        create :shop_book, shop: shop1, book: book1, copies_sold: 100_500, copies_in_stock: 5
      end
      let!(:shop_book2) { create :shop_book, shop: shop1, book: book2, copies_sold: 42, copies_in_stock: 10 }
      let!(:shop_book3) { create :shop_book, shop: shop2, book: book1, copies_sold: 100_543 }
      let!(:shop_book4) { create :shop_book, shop: shop2, book: book2, copies_sold: 1, copies_in_stock: 0 }
      let! :shop_book5 do
        create :shop_book, shop: shop3, book: book1, copies_sold: 999_999, copies_in_stock: 0
      end

      it 'renders shops, that sell books of a publisher', :aggregate_failures do
        expect(parsed_response).to eq(
          'status' => 200,
          'shops'  => [
            {
              'id'               => shop2.id,
              'name'             => shop2.name,
              'books_sold_count' => shop_book3.copies_sold + shop_book4.copies_sold,
              'books_in_stock'   => [
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
              'books_in_stock'   => [
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

      include_examples 'rendering 404 error'
    end
  end
end
