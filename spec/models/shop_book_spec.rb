require 'rails_helper'

RSpec.describe ShopBook, type: :model do
  it_behaves_like 'a model with a factory'

  describe 'after create commit hook' do
    subject(:instance_creation) { instance.save }

    let(:instance) { build described_class.to_s.underscore }

    it 'calls #update_publisher_shop' do
      allow(instance).to receive :update_publisher_shop
      instance_creation
      expect(instance).to have_received :update_publisher_shop
    end
  end

  describe 'after update commit hook' do
    subject(:instance_update) { instance.update copies_sold: 123 }

    let!(:instance) { create described_class.to_s.underscore }

    it 'calls #update_publisher_shop' do
      allow(instance).to receive :update_publisher_shop
      instance_update
      expect(instance).to have_received :update_publisher_shop
    end
  end

  describe '#update_publisher_shop' do
    subject(:method_call) { instance.update_publisher_shop }

    # rubocop:disable RSpec/AnyInstance
    before { allow_any_instance_of(PublisherShop).to receive :update_books_sold_count }
    # rubocop:enable RSpec/AnyInstance
    let!(:instance) { build described_class.to_s.underscore }

    shared_examples_for 'creating PublisherShop' do
      it 'creates PublisherShop with matching #publisher and #shop' do
        expect { method_call }.to change {
          PublisherShop.where(publisher_id: instance.book.publisher.id, shop_id: instance.shop.id).count
        }.by 1
      end
    end

    include_examples 'creating PublisherShop'

    it 'calls PublisherShop#update_books_sold_count' do
      # rubocop:disable RSpec/AnyInstance
      expect_any_instance_of(PublisherShop).to receive :update_books_sold_count
      # rubocop:enable RSpec/AnyInstance
      method_call
    end

    context 'when there is another PublisherShop present' do
      let!(:publisher) { create :publisher }
      let!(:shop) { create :shop }
      let!(:publisher_shop) { create :publisher_shop, publisher: publisher, shop: shop }

      include_examples 'creating PublisherShop'

      context 'with matching #publisher' do
        let(:publisher) { instance.book.publisher }

        include_examples 'creating PublisherShop'
      end

      context 'with matching #shop' do
        let(:shop) { instance.shop }

        include_examples 'creating PublisherShop'
      end

      context 'with matching #publisher and #shop' do
        let(:publisher) { instance.book.publisher }
        let(:shop) { instance.shop }

        it 'does not create a new PublisherShop' do
          expect { method_call }.not_to change(PublisherShop, :count)
        end

        it 'calls PublisherShop#update_books_sold_count' do
          # rubocop:disable RSpec/AnyInstance
          expect_any_instance_of(PublisherShop).to receive :update_books_sold_count
          # rubocop:enable RSpec/AnyInstance
          method_call
        end
      end
    end
  end
end
