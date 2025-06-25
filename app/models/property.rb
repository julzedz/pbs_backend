class Property < ApplicationRecord
  enum purpose: { rent: 0, sale: 1 }
  enum property_type: { house: 0, land: 1 }
  belongs_to :user
  belongs_to :locality
  has_one_attached :picture
  has_many :property_features, dependent: :destroy
  has_many :features, through: :property_features
end
