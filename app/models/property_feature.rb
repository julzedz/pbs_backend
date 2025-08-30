class PropertyFeature < ApplicationRecord
  belongs_to :property
  belongs_to :feature

  def self.ransackable_associations(auth_object = nil)
    ["property", "feature"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "property_id", "feature_id", "created_at", "updated_at"]
  end
end
