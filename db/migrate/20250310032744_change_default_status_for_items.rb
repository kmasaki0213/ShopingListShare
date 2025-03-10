class ChangeDefaultStatusForItems < ActiveRecord::Migration[7.1]
  def change
    change_column_default :items, :status, "unpurchased"
  end
end
