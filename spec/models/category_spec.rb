require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) do
    FactoryBot.create(:user)
  end

  describe "creation" do
    it "can be created if valid" do
      category = Category.create(
        user: user,
        name: 'category',
      )
      expect(category).to be_valid
    end

    it "must have a unique name for this user" do
      category = Category.create(
        user: user,
        name: 'category',
      )
      expect(category).to be_valid

      category2 = Category.create(
        user: user,
        name: 'category',
      )

      expect(category2).to_not be_valid
    end
  end

  describe "deletion" do
    it "deletes child category_rules" do
      category = FactoryBot.create(:category, user: user)

      category_rule = FactoryBot.create(:category_rule, category: category)

      expect { category.destroy }.to change(Category, :count).by(-1)
        .and change(CategoryRule, :count).by(-1)
    end

    it "nullifies child bank transactions" do
      category = FactoryBot.create(:category, user: user)

      bank_transaction = FactoryBot.create(:bank_transaction, category: category)

      expect { category.destroy }.to change(Category, :count).by(-1)
        .and change(BankTransaction, :count).by (0)

      expect(BankTransaction.find(bank_transaction.id).category).to eq(nil)
    end
  end
end
