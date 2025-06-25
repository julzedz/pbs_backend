class Feature < ApplicationRecord
  has_many :property_features, dependent: :destroy
  has_many :properties, through: :property_features
  validates :name, uniqueness: true, presence: true
end
