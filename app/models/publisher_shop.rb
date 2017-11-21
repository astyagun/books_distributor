class PublisherShop < ApplicationRecord
  belongs_to :publisher
  belongs_to :shop

  validates :publisher, :shop, presence: true
end
