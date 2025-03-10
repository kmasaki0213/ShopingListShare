class AddPurchasedAtToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :purchased_at, :datetime, null: true
  end
end
