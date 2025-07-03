class PropertySerializer
  include JSONAPI::Serializer
  attributes :id, :title, :purpose, :street, :property_type, :price, :description, :bedrooms, :bathrooms, :instagram_video_link, :created_at

  belongs_to :user
  belongs_to :locality
  has_many :features

  attribute :image_url do |property|
    Rails.application.routes.url_helpers.rails_blob_url(property.picture) if property.picture.attached?
  end
end 