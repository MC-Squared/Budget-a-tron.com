class AddStartBalanceToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :start_balance, :decimal, null: false, default: 0
  end
end
