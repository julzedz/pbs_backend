class State < ApplicationRecord
  has_many :localities, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    ["localities", "properties"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "created_at", "updated_at"]
  end
end
