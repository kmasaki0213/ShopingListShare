class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :price, null: false
      t.integer :quantity, default: 1, null: false
      t.string :status, default: 'pending' 
      t.references :user, null: false, foreign_key: true, index: true 
      t.references :team, null: false, foreign_key: true, index: true 

      t.timestamps
    end
  end
end
