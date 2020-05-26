class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :picture
  validates :content, presence: true
end

  def comment?(comment, user)
    if comment.user_id == user.id
      return true
    end
  end
