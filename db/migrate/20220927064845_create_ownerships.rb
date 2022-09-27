class CreateOwnerships < ActiveRecord::Migration[7.0]
  def change
  
    create_table :ownerships do |t|
      t.references :account, :foreign_key => { :on_delete => :cascade }
      t.references :client, :foreign_key => { :on_delete => :restrict }
      t.references :branch, :foreign_key => { :on_delete => :restrict }
      t.string :accountable_type
      t.datetime :last_access, :default => -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
