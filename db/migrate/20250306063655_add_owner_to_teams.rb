class AddOwnerToTeams < ActiveRecord::Migration[7.1]
  def change
    add_reference :teams, :owner, foreign_key: { to_table: :users }
  end
end
