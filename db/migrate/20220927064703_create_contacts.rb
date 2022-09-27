class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts, :id => false do |t|
      t.string :name, :limit => 64
      t.string :phone, :limit => 64
      t.string :email, :limit => 64, :comment => "Email"
      t.string :relationship, :limit => 64
      t.references :client, :primary_key => true, :index => true, :foreign_key => { :on_delete => :cascade }

      t.timestamps
    end
  end
end
