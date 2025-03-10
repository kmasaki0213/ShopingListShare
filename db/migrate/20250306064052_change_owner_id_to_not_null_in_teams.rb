class ChangeOwnerIdToNotNullInTeams < ActiveRecord::Migration[7.1]
  def change
    change_column_null :teams, :owner_id, false
  end
end

