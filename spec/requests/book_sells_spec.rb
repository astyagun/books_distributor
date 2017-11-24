require 'rails_helper'

RSpec.describe 'Book sells', type: :request do
  describe 'POST /shops/:shop_id/books/:book_id/sells' do
    subject :parsed_response do
      post shop_book_sells_path shop_id, book_id, amount: amount
      JSON.parse response.body
    end

    let!(:shop_book) { create :shop_book, shop: shop, book: book }
    let(:shop) { create :shop }
    let(:book) { create :book }
    let(:shop_id) { shop.id }
    let(:book_id) { book.id }
    let(:amount) { nil }

    shared_examples_for 'selling books' do |number|
      it "sells #{number} #{'book'.pluralize(number)}", :aggregate_failures do
        expect { parsed_response }.to change { shop_book.reload.copies_sold }.by(number).
          and change { shop_book.reload.copies_in_stock }.by(-number)
        expect(parsed_response).to eq 'status' => 200
        expect(response).to have_http_status 200
      end
    end

    include_examples 'selling books', 1

    context 'when amount is 500' do
      let(:amount) { '500' }

      include_examples 'selling books', 500
    end

    context 'when amount is a string' do
      let(:amount) { 'lorem' }

      it 'renders 400 error', :aggregate_failures do
        expect { parsed_response }.to change { shop_book.reload.copies_sold }.by(0).
          and change { shop_book.reload.copies_in_stock }.by(0)
        expect(parsed_response).to eq(
          'status' => 400,
          'detail' => 'Amount parameter has an unacceptable value, must be an integer',
          'code'   => 4001
        )
        expect(response).to have_http_status 400
      end
    end

    context 'when there is no shop for a given shop_id parameter' do
      let(:shop_id) { 123_456 }

      include_examples 'rendering 404 error'
    end

    context 'when there is no book for a given book_id parameter' do
      let(:book_id) { 123_456 }

      include_examples 'rendering 404 error'
    end
  end
end
