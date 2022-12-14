class CreateDepositAccounts <ActiveRecord::Migration[6.1]
  def change
    create_table :deposit_accounts do |t|
      t.float :interest_rate, :default => 1.0
      t.string :currency, :limit => 3, :default => "BTC"
    end
  end
end
