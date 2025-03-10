class Item < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :quantity, numericality: { greater_than: 0 }

  enum status: { unpurchased: "unpurchased", purchased: "purchased", rejected: "rejected" } # ✅ 修正

  scope :recent_purchases, -> { where(status: :purchased).where("purchased_at >= ?", 3.days.ago) }
  scope :history, -> { where(status: :purchased).where("purchased_at < ?", 3.days.ago) }

  def purchased?
    status == "purchased"
  end

  def rejected?
    status == "rejected"
  end
end
