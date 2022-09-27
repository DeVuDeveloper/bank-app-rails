class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :person_id, :limit => 18, :unique => true, :null => false
      t.string :name, :limit => 64
      t.string :phone, :limit => 64
      t.string :address, :limit => 256

      t.references :manager, :null => true, :index => true, :foreign_key => { :to_table => :staffs, :on_delete => :restrict }
      t.integer :manager_type, :limit => 1, :default => 0, :null => true

      t.timestamps
    end
  end
end
