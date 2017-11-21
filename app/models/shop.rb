class Shop < ApplicationRecord
  has_many :book_shops, dependent: :destroy
  has_many :books, through: :book_shops # rubocop:disable Rails/HasManyOrHasOneDependent

  validates :name, presence: true
end
