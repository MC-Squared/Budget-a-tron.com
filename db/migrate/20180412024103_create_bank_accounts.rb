class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.string :bank_number
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
