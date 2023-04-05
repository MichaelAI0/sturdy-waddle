class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validates_uniqueness_of :follower_id, scope: :following_id
end
