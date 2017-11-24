require 'rails_helper'

RSpec.describe SellShopBook do
  describe '.call' do
    subject(:method_call) { described_class.call shop_book, amount }

    before { allow(shop_book).to receive :update_publisher_shop }
    let!(:shop_book) { create :shop_book }
    let(:amount) { 1 }

    it 'calls #update_publisher_shop' do
      method_call
      expect(shop_book).to have_received :update_publisher_shop
    end

    it 'increments #copies_sold by 1' do
      expect { method_call }.to change { shop_book.reload.copies_sold }.by 1
    end

    it 'decrements #copies_in_stock by 1' do
      expect { method_call }.to change { shop_book.reload.copies_in_stock }.by(-1)
    end

    it 'updates #updated_at timestamp' do
      expect { method_call }.to(change { shop_book.reload.updated_at })
    end

    context 'when amount is 42' do
      let(:amount) { 42 }

      it 'increments #copies_sold by 42' do
        expect { method_call }.to change { shop_book.reload.copies_sold }.by 42
      end

      it 'decrements #copies_in_stock by 42' do
        expect { method_call }.to change { shop_book.reload.copies_in_stock }.by(-42)
      end
    end

    context 'when amount is a string' do
      let(:amount) { 'asasdafa' }

      it 'raises AmountArgumentError' do
        expect { method_call }.to raise_error AmountArgumentError
      end
    end

    context 'when calling method concurrently' do
      let(:concurrent_shop_book) { ShopBook.find shop_book.id }

      it 'increments #copies_sold by 2' do
        expect do
          described_class.call concurrent_shop_book, amount
          method_call
        end.to change { shop_book.reload.copies_sold }.by 2
      end
    end
  end
end
