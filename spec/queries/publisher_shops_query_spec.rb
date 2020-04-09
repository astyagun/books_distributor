require 'rails_helper'

RSpec.describe PublisherShopsQuery do
  describe '.call' do
    subject(:result) { described_class.call publisher }

    let!(:publisher) { create :publisher }
    let!(:shop) { create :shop }
    let!(:book) { create :book, publisher: publisher }
    let! :shop_book do
      create :shop_book, shop: shop, book: book, copies_sold: 100, copies_in_stock: copies_in_stock
    end
    let!(:publisher_shop) { PublisherShop.find_by publisher: publisher, shop: shop }
    let(:copies_in_stock) { 100 }

    it { is_expected.to eq [publisher_shop] }

    context 'when publisher_shop belongs to another publisher' do
      before { publisher_shop.update publisher: create(:publisher) }

      it { is_expected.to eq [] }
    end

    context 'when there are 0 books currently in stock' do
      let(:copies_in_stock) { 0 }

      it { is_expected.to eq [] }
    end

    context 'when there are several publisher_shops with different amounts of books sold' do
      let!(:shop_book2) { create :shop_book, book: book, copies_sold: 500 }
      let!(:shop_book3) { create :shop_book, book: book, copies_sold: 20 }
      let!(:publisher_shop2) { PublisherShop.find_by publisher: publisher, shop: shop_book2.shop }
      let!(:publisher_shop3) { PublisherShop.find_by publisher: publisher, shop: shop_book3.shop }

      it 'orders them by #books_sold_count in descending order' do
        expect(result.pluck(:id)).to eq [publisher_shop2.id, publisher_shop.id, publisher_shop3.id]
      end
    end

    context 'when there are several books from this publisher in this shop' do
      let!(:book2) { create :book, publisher: publisher }
      let!(:book3) { create :book, publisher: publisher }
      let!(:shop_book2) { create :shop_book, shop: shop, book: book2, copies_in_stock: 500 }
      let!(:shop_book3) { create :shop_book, shop: shop, book: book3, copies_in_stock: 20 }

      it 'orders them by ShopBook#copies_in_stock in descending order' do
        expect(result.first.shop.shop_books.map(&:book).map(&:id)).to eq [book2.id, book.id, book3.id]
      end

      context 'when a book is out of stock' do
        let(:copies_in_stock) { 0 }

        it 'is not returned' do
          expect(result.first.shop.shop_books.map(&:book).map(&:id)).to eq [book2.id, book3.id]
        end
      end
    end

    context 'when shop sells a book of another publisher' do
      let!(:another_publisher) { create :publisher }
      let!(:another_book) { create :book, publisher: another_publisher }
      let!(:another_shop_book) { create :shop_book, shop: shop, book: another_book }

      it 'does not return this book' do
        expect(result.first.shop.shop_books.map(&:id)).to eq [shop_book.id]
      end
    end

    context 'when shop_book and a book of the publisher exist' do
      before { create :shop_book, book: create(:book, publisher: publisher), shop: shop }

      it 'eager loads shops, shop_books and books', :aggregate_failures do
        expect(result.first.association(:shop)).to be_loaded, 'Shops are not eager loaded'
        expect(result.first.shop.association(:shop_books)).to be_loaded, 'ShopBooks are not eager loaded'
        expect(result.first.shop.shop_books.first.association(:book)).to(
          be_loaded, 'Books are not eager loaded'
        )
      end
    end
  end
end
