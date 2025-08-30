class Feature < ApplicationRecord
  has_many :property_features, dependent: :destroy
  has_many :properties, through: :property_features
  validates :name, uniqueness: true, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["property_features", "properties"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "created_at", "updated_at"]
  end
end
