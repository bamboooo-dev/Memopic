class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :picture
  validates :content, presence: true
end
