require 'rails_helper'

RSpec.describe 'Book sells', type: :request do
  describe 'POST /shops/:shop_id/books/:book_id/sells' do
    subject :parsed_response do
      post shop_book_sells_path shop_id, book_id, amount: amount
      JSON.parse response.body
    end

    let!(:book_shop) { create :book_shop, shop: shop, book: book }
    let(:shop) { create :shop }
    let(:book) { create :book }
    let(:shop_id) { shop.id }
    let(:book_id) { book.id }
    let(:amount) { nil }

    it 'sells a book', :aggregate_failures do
      expect { parsed_response }.to change { book_shop.reload.copies_sold }.by 1
      expect(parsed_response).to eq 'status' => 200
      expect(response).to have_http_status 200
    end

    context 'when amount is 500' do
      let(:amount) { '500' }

      it 'sells 500 books', :aggregate_failures do
        expect { parsed_response }.to change { book_shop.reload.copies_sold }.by 500
        expect(parsed_response).to eq 'status' => 200
        expect(response).to have_http_status 200
      end
    end

    context 'when amount is a string' do
      let(:amount) { 'lorem' }

      it 'renders error', :aggregate_failures do
        expect { parsed_response }.not_to change { book_shop.reload.copies_sold }
        expect(parsed_response).to eq(
          'status' => 400,
          'detail' => 'Amount parameter has unacceptable value',
          'code'   => 4001
        )
        expect(response).to have_http_status 400
      end
    end

    context 'when shop_id param corresponds to non existent shop' do
      let(:shop_id) { 123_456 }

      it 'returns error', :aggregate_failures do
        expect(parsed_response).to eq(
          'status' => 404,
          'detail' => 'Record not found'
        )
        expect(response).to have_http_status :not_found
      end
    end

    context 'when book_id param corresponds to non existent book' do
      let(:book_id) { 123_456 }

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
