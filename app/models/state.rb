class State < ApplicationRecord
  has_many :localities, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
