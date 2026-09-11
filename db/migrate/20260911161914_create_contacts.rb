class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :contacts, [:requester_id, :recipient_id], unique: true
  end
end