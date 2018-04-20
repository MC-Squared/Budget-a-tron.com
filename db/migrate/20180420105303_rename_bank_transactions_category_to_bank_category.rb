class RenameBankTransactionsCategoryToBankCategory < ActiveRecord::Migration[5.2]
  def change
    rename_column :bank_transactions, :category, :bank_category
    rename_column :bank_transactions, :adress, :address
  end
end
