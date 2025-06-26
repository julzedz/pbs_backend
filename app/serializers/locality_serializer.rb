class LocalitySerializer
  include JSONAPI::Serializer
  attributes :id, :name

  belongs_to :state
end 