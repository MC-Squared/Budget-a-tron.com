require 'rails_helper'

RSpec.describe BankTransaction, type: :model do
  let (:bank_account) { FactoryBot.create(:bank_account) }
  let(:user) { bank_account.user }

  describe "creation" do
    it "can be created if valid" do
      transaction = BankTransaction.create(
        bank_account: bank_account,
        payee: 'test payee',
        amount: 123.45,
      )
      expect(transaction).to be_valid
    end

    it "requires an amount" do
      transaction = BankTransaction.create(
        bank_account: bank_account,
        payee: 'test payee',
      )
      expect(transaction).to_not be_valid
    end
  end

  describe "sum_by_day scope" do
    it "calculates the sum per day" do
      BankTransaction.create(
        date: Date.today,
        bank_account: bank_account,
        amount: 123,
        payee: 'test payee'
      )
      BankTransaction.create(
        date: Date.today,
        bank_account: bank_account,
        amount: 456,
        payee: 'adsf'
      )
      BankTransaction.create(
        date: Date.today - 1.day,
        bank_account: bank_account,
        amount: 1000,
        payee: 'test'
      )

      sums = bank_account.bank_transactions.sum_by_day
      expect(sums[Date.today - 1.day]).to eq(1000)
      expect(sums[Date.today]).to eq(579)
    end
  end

  describe "apply_categories_from_rules" do
    it "applies the correct categories" do
      BankTransaction.create(
        date: Date.today,
        bank_account: bank_account,
        amount: 123,
        payee: 'match1'
      )
      BankTransaction.create(
        date: Date.today,
        bank_account: bank_account,
        amount: 456,
        memo: 'long match2 string'
      )
      BankTransaction.create(
        date: Date.today - 1.day,
        bank_account: bank_account,
        amount: 1000,
        payee: 'no match for me'
      )

      cat1 = FactoryBot.create(:category, user: user)
      cat2 = FactoryBot.create(:category, user: user)

      CategoryRule.create(category: cat1, match_payee: 'match1')
      CategoryRule.create(category: cat2, match_memo: 'match2')

      user.bank_transactions.apply_categories_from_rules(user.category_rules)
      expect(BankTransaction.first.category).to eq(cat1)
      expect(BankTransaction.second.category).to eq(cat2)
      expect(BankTransaction.last.category).to eq(nil)
    end

    it "does not overwrite existing categories" do
      cat1 = FactoryBot.create(:category, user: user)
      cat2 = FactoryBot.create(:category, user: user)

      BankTransaction.create(
        date: Date.today,
        bank_account: bank_account,
        amount: 123,
        payee: 'match',
        category: cat1
      )

      CategoryRule.create(category: cat2, match_payee: 'match')

      user.bank_transactions.apply_categories_from_rules(user.category_rules)
      expect(BankTransaction.first.category).to eq(cat1)
    end
  end
end
