class Tweet < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 280 }
  has_many :likes, dependent: :destroy
  has_many :liked_by, through: :likes, source: :user
  has_many :retweets, dependent: :destroy
  has_many :retweeted_by, through: :retweets, source: :user
end
