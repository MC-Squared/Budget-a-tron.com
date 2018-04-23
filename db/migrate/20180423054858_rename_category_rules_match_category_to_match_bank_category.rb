class RenameCategoryRulesMatchCategoryToMatchBankCategory < ActiveRecord::Migration[5.2]
  def change
    rename_column :category_rules, :match_category, :match_bank_category
  end
end
