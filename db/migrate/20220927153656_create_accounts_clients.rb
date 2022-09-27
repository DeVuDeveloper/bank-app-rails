class CreateAccountsClients < ActiveRecord::Migration[6.1]
  def self.up
    create_table :accounts_clients, id: false do |t|
      t.references :account, null: false
      t.references :client, null: false
    end

    # Add an unique index for better join speed!
    add_index(:accounts_clients, [:account_id, :client_id], :unique => true)
  end

  def self.down
    drop_table :students_subjects
  end
end