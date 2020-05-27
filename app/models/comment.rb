class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :picture
  validates :content, presence: true

  def commenter?(u)
    user == u
  end
end
