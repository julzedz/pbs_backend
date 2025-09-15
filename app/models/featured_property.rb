class FeaturedProperty < ApplicationRecord
  validates :property_ids, presence: true
  def properties
    Property.where(id: property_ids)
  end
end
