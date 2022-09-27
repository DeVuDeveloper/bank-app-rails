class CreateStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :staffs do |t|
      t.string :person_id, :limit => 18, :unique => true, :null => false
      t.string :name, :limit => 64
      t.string :phone, :limit => 64
      t.string :address, :limit => 256
      t.date :start_date, :default => "CURRENT_TIMESTAMP"
      t.boolean :manager, :default => -> { false }

      t.references :branch, :index => true, :foreign_key => { :on_delete => :restrict }
      t.references :department, :index => true, :foreign_key => { :on_delete => :restrict }

      t.timestamps
    end
  end
end
