class CreateClientsLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :clients_loans do |t|
      t.references :loan, :index => true, :foreign_key => { :on_delete => :cascade }
      t.references :client, :index => true, :foreign_key => { :on_delete => :restrict }
    end
  end
end
