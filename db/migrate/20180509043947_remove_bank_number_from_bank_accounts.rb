class RemoveBankNumberFromBankAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :bank_accounts, :bank_number
  end
end
