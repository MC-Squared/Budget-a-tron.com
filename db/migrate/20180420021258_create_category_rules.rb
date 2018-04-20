class CreateCategoryRules < ActiveRecord::Migration[5.2]
  def change
    create_table :category_rules do |t|
      t.references :category, foreign_key: true
      t.string :match_status
      t.string :match_payee
      t.string :match_memo
      t.string :match_address
      t.string :match_category

      t.timestamps
    end
  end
end
