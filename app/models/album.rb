class Album < ApplicationRecord
  has_many :pictures, dependent: :destroy
  validates :name, presence: true
end
