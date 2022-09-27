class CreateBranches < ActiveRecord::Migration[7.0]
  def change
      create_table :branches do |t|
        t.string :name, :limit => 64, :unique => true
        t.string :city, :limit => 64
        t.decimal :assets, :precision => 12, :scale => 2, :default => 0.0
  
        t.timestamps
      end
    end
  end
