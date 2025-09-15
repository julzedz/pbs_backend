class FeaturedProperty < ApplicationRecord
  def properties
    Property.where(id: property_ids)
  end
end
