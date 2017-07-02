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
  
  # User:relationship= 1：多
  has_many :relationships
  
  # user.followings と書けば、user がフォローしている User 達を取得できるようにする。
  # その機能を提供するのが has_many ..., through: ...
  # "through: relationships"で、relationshipsを中間テーブルに指定
  # "followings"は、筆者が命名したもので、クラス名とは関係ない。
  has_many :followings, through: :relationships, source: :follow
  
  # "has_many :relationships"の逆方向
  # "has_many :relationships"は、筆者が命名したもので、クラス名やオブジェクト名ではない
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  
  # フォロー／アンフォローとは、中間テーブルのレコードを保存／削除することです
  # 注意点：1. 自分自身ではないか。2. すでにフォローしているか
  def follow(other_user)
    unless self == other_user
      # findで見つかればrelationshipを返し、見つからないときは、build + saveする
      # すでにフォローされているときに、フォローが重複して保存されなくなる
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    # Microspostのレコードで、フォローしているユーザ + 自分自身のidとなる
    # レコードをすべて取得している
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end
