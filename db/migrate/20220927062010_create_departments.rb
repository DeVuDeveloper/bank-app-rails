class CreateDepartments < ActiveRecord::Migration[6.1]
  def change
    create_table :departments do |t|
      t.string :name, :limit => 64, :unique => true
      t.string :kind, :limit => 64

      t.timestamps
    end
  end
end

