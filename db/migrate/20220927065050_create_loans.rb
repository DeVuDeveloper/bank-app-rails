class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.decimal :amount, precision: 12, scale: 2, default: 0.0
      t.references :branch, index: true, foreign_key: { on_delete: :restrict }

      t.timestamps
    end
  end
end
