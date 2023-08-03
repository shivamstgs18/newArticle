class Article < ApplicationRecord

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  
  validates :title, presence: true, length: {minimum: 6, maximum: 100}
  validates :description, presence: true, length: {minimum: 10, maximum: 300}

  def increment_views
    self.views ||= 0
    self.views += 1
    save
  end

  def total_likes
    likes.try(:count) || 0
  end
end