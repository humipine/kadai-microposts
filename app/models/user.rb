class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :age, presence: true, length: { maximum: 3 }
  validates :selfintro, presence: false, length: { maximum: 255 }
  
  has_secure_password
  
  #User: microposts = 1:多になるので、以下の記述が必要
  has_many :microposts
end
