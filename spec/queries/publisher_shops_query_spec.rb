require 'rails_helper'

RSpec.describe PublisherShopsQuery do
  describe '.call' do
    subject(:result) { described_class.call publisher }

    let!(:publisher) { create :publisher }
    let!(:book) { create :book, publisher: publisher }
    let!(:shop) { create :shop }
    let!(:book_shop) { create :book_shop, book: book, shop: shop, copies_sold: 100 }
    let!(:publisher_shop) { PublisherShop.find_by publisher: publisher, shop: shop }

    it { is_expected.to eq [publisher_shop] }

    context 'when publisher_shop belongs to another publisher' do
      before { publisher_shop.update_attributes publisher: create(:publisher) }

      it { is_expected.to eq [] }
    end

    context 'when there are several publisher_shops with different amounts of books sold' do
      let!(:book_shop2) { create :book_shop, book: book, copies_sold: 500 }
      let!(:book_shop3) { create :book_shop, book: book, copies_sold: 20 }
      let!(:publisher_shop2) { PublisherShop.find_by publisher: publisher, shop: book_shop2.shop }
      let!(:publisher_shop3) { PublisherShop.find_by publisher: publisher, shop: book_shop3.shop }

      it 'orders them by #books_sold_count in descending order' do
        expect(result.pluck(:id)).to eq [publisher_shop2.id, publisher_shop.id, publisher_shop3.id]
      end
    end

    context 'when there are several books from this publisher in this shop' do
      let!(:book2) { create :book, publisher: publisher }
      let!(:book3) { create :book, publisher: publisher }
      let!(:book_shop2) { create :book_shop, book: book2, shop: shop, copies_sold: 500 }
      let!(:book_shop3) { create :book_shop, book: book3, shop: shop, copies_sold: 20 }

      it 'orders them by BookShop#copies_sold in descending order' do
        expect(result.first.shop.book_shops.map(&:book).map(&:id)).to eq [book2.id, book.id, book3.id]
      end
    end

    context 'when shop sells a book of another publisher' do
      let!(:another_publisher) { create :publisher }
      let!(:another_book) { create :book, publisher: another_publisher }
      let!(:another_book_shop) { create :book_shop, book: another_book, shop: shop }

      it 'does not return this book' do
        expect(result.first.shop.book_shops.map(&:id)).to eq [book_shop.id]
      end
    end

    context 'when book_shop and book of the publisher exist' do
      before { create :book_shop, book: create(:book, publisher: publisher), shop: shop }

      it 'eager loads shops, book_shops and books', :aggregate_failures do
        expect(result.first.association(:shop)).to be_loaded, 'Shops are not eager loaded'
        expect(result.first.shop.association(:book_shops)).to be_loaded, 'BookShops are not eager loaded'
        expect(result.first.shop.book_shops.first.association(:book)).to(
          be_loaded, 'Books are not eager loaded'
        )
      end
    end
  end
end
