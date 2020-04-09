RSpec.shared_examples_for 'a model with a factory' do
  let(:factory_name) { described_class.to_s.underscore }

  describe "#{described_class} factory" do
    it 'is valid' do
      factory = FactoryBot.create factory_name
      expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") }
    end

    # Test each trait
    FactoryBot
      .factories[described_class.to_s.underscore].definition.defined_traits.map(&:name).each do |trait_name|
      context "with trait #{trait_name}" do
        it 'is valid' do
          factory = FactoryBot.create factory_name, trait_name
          expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") }
        end
      end
    end
  end
end
