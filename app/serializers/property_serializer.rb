class PropertySerializer
  include JSONAPI::Serializer
  attributes :id, :title, :purpose, :street, :property_type, :price, :description, :contact_name, :contact_phone, :bedrooms, :bathrooms, :instagram_video_link, :created_at

  belongs_to :user
  belongs_to :locality
  belongs_to :state
  has_many :features

  attribute :image_url do |property|
    property.picture.url if property.picture.attached?
  end
end 