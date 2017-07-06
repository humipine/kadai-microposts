class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :addtofavorite, class_name: 'Micropost'
  
  validates :user_id, presence: true
  validates :addtofavorite_id, presence: true

end
