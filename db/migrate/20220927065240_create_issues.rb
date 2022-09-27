class CreateIssues <ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.references :loan, :index => true, :foreign_key => { :on_delete => :cascade }
      t.date :date, :default => "CURRENT_TIMESTAMP"
      t.decimal :amount, :precision => 12, :scale => 2, :default => 0.0
    end
  end
end
