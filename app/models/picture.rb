class Picture < ApplicationRecord
  belongs_to :album
  has_many :users, through: :favorites
end
