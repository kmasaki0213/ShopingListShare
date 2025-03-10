class Team < ApplicationRecord
  belongs_to :owner, class_name: 'User' # チームの作成者

  # ユーザーとの多対多関係
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :items, dependent: :destroy

  validates :name, presence: true
end
