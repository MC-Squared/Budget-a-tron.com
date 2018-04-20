class AddCategoryToBankTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :bank_transactions, :category, foreign_key: true
  end
end
