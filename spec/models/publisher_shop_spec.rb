require 'rails_helper'

RSpec.describe PublisherShop, type: :model do
  it_behaves_like 'a model with a factory'

  describe '#update_books_sold_count' do
    subject(:method_call) { instance.update_books_sold_count }

    before { allow_any_instance_of(BookShop).to receive :update_publisher_shop }
    let!(:instance) { create described_class.to_s.underscore }

    it 'does not change #books_sold_count' do
      expect { method_call }.not_to change { instance.reload.books_sold_count }
    end

    context 'when book_shop exists' do
      let!(:book_publisher) { create :publisher }
      let!(:book) { create :book, publisher: book_publisher }
      let!(:shop) { create :shop }
      let!(:book_shop) { create :book_shop, book: book, shop: shop  }

      it 'does not change #books_sold_count' do
        expect { method_call }.not_to change { instance.reload.books_sold_count }
      end

      context 'and it is of the same publisher and shop' do
        let(:book_publisher) { instance.publisher }
        let(:shop) { instance.shop }

        it 'updates #books_sold_count to equal book_shop#copies_sold' do
          expect { method_call }.to change { instance.reload.books_sold_count }.
            from(0).
            to(book_shop.copies_sold)
        end

        context 'and there is another book_shop with the same publisher and shop' do
          let!(:another_book) { create :book, publisher: instance.publisher }
          let!(:another_book_shop) { create :book_shop, book: another_book, shop: instance.shop }

          it 'updates #books_sold_count to be the sum of #copies_sold of these book_shops' do
            expect { method_call }.to change { instance.reload.books_sold_count }.
              from(0).
              to(book_shop.copies_sold + another_book_shop.copies_sold)
          end
        end
      end

      context "and it's publisher is the same" do
        let(:publisher) { instance.book.publisher }

        it 'does not change #books_sold_count' do
          expect { method_call }.not_to change { instance.reload.books_sold_count }
        end
      end

      context "and it's shop is the same" do
        let(:shop) { instance.shop }

        it 'does not change #books_sold_count' do
          expect { method_call }.not_to change { instance.reload.books_sold_count }
        end
      end
    end
  end
end
