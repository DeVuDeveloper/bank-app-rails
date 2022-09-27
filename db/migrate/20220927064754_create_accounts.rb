class CreateAccounts <ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.references :branch, :index => true, :foreign_key => { :on_delete => :restrict }
      t.references :accountable, :null => false, :polymorphic => true
      t.decimal :balance, :precision => 12, :scale => 2, :default => 0.0
      t.date :open_date, :default => "CURRENT_TIMESTAMP"

      t.timestamps
    end
  end
end
