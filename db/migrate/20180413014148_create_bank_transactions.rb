class CreateBankTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_transactions do |t|
      t.string :status
      t.integer :number
      t.date :date
      t.decimal :amount
      t.string :payee
      t.string :memo
      t.string :adress
      t.string :category
      t.references :bank_account, foreign_key: true

      t.timestamps
    end
  end
end
