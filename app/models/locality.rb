class Locality < ApplicationRecord
  belongs_to :state
  validates :name, presence: true
end
