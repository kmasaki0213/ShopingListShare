class RemoveTeamIdFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :team_id, :integer
  end
end
