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
    subject(:instance_update) { instance.update_attributes copies_sold: 123 }

    let!(:instance) { create described_class.to_s.underscore }

    it 'calls #update_publisher_shop' do
      allow(instance).to receive :update_publisher_shop
      instance_update
      expect(instance).to have_received :update_publisher_shop
    end
  end

  describe '#increment_copies_sold_by' do
    subject(:method_call) { instance.increment_copies_sold_by amount }

    before { allow(instance).to receive :update_publisher_shop }
    let!(:instance) { create described_class.to_s.underscore }
    let(:amount) { 1 }

    it 'calls #update_publisher_shop' do
      method_call
      expect(instance).to have_received :update_publisher_shop
    end

    it 'increments #copies_sold by 1' do
      expect { method_call }.to change { instance.reload.copies_sold }.by 1
    end

    it 'updates #updated_at timestamp' do
      expect { method_call }.to change { instance.reload.updated_at }
    end

    context 'when amount is 42' do
      let(:amount) { 42 }

      it 'increments #copies_sold by 42' do
        expect { method_call }.to change { instance.reload.copies_sold }.by 42
      end
    end

    context 'when amount is a string' do
      let(:amount) { 'asasdafa' }

      it 'it raises AmountArgumentError' do
        expect { method_call }.to raise_error AmountArgumentError
      end
    end

    context 'when calling method concurrently' do
      let(:concurrent_instance) { described_class.find instance.id }

      it 'increments #copies_sold by 2' do
        expect do
          concurrent_instance.increment_copies_sold_by amount
          method_call
        end.to change { instance.reload.copies_sold }.by 2
      end
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
        expect { method_call }.to change(
          PublisherShop.where(publisher_id: instance.book.publisher_id, shop_id: instance.shop_id),
          :count
        ).by 1
      end
    end

    it_behaves_like 'creating PublisherShop'

    it 'calls PublisherShop#update_books_sold_count' do
      expect_any_instance_of(PublisherShop).to receive :update_books_sold_count
      method_call
    end

    context 'when there is another PublisherShop present' do
      let!(:publisher) { create :publisher }
      let!(:shop) { create :shop }
      let!(:publisher_shop) { create :publisher_shop, publisher: publisher, shop: shop }

      it_behaves_like 'creating PublisherShop'

      context 'with matching #publisher' do
        let(:publisher) { instance.book.publisher }

        it_behaves_like 'creating PublisherShop'
      end

      context 'with matching #shop' do
        let(:shop) { instance.shop }

        it_behaves_like 'creating PublisherShop'
      end

      context 'with matching #publisher and #shop' do
        let(:publisher) { instance.book.publisher }
        let(:shop) { instance.shop }

        it 'does not create a new PublisherShop' do
          expect { method_call }.not_to change(PublisherShop, :count)
        end

        it 'calls PublisherShop#update_books_sold_count' do
          expect_any_instance_of(PublisherShop).to receive :update_books_sold_count
          method_call
        end
      end
    end
  end
end
