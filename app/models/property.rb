class Property < ApplicationRecord
  enum purpose: { rent: 0, sale: 1 }
  enum property_type: { house: 0, land: 1 }
  belongs_to :user
  belongs_to :locality
  belongs_to :state
  has_one_attached :picture, dependent: :purge_later
  has_many :property_features, dependent: :destroy
  has_many :features, through: :property_features

  def self.ransackable_associations(auth_object = nil)
    ["user", "locality", "state", "property_features", "features"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "purpose", "street", "property_type", "price", "description", "bedrooms", "bathrooms", "instagram_video_link", "contact_name", "contact_phone", "user_id", "locality_id", "state_id", "created_at", "updated_at"]
  end
end
