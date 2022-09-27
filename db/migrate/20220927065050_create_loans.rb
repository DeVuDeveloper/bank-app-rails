class CreateLoans <ActiveRecord::Migration[6.1]
  def change
    create_table :loans do |t|
      t.integer :amount
      t.references :branch, index: true, foreign_key: { on_delete: :restrict }

      t.timestamps
    end
  end
end
