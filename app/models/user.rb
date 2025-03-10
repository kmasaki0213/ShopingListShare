class User < ApplicationRecord
  # Devise の設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザーとチームの関係（多対多）
  has_many :memberships
  has_many :teams, through: :memberships
end
