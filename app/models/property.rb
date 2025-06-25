class Property < ApplicationRecord
  belongs_to :user
  belongs_to :locality
  has_many :property_features, dependent: :destroy
  has_many :features, through: :property_features
end
