class Locality < ApplicationRecord
  belongs_to :state
  validates :name, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["state", "properties"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "state_id", "created_at", "updated_at"]
  end
end
