require 'rails_helper'

RSpec.describe BankTransaction, type: :model do
  describe "creation" do
    let (:bank_account) do
      FactoryBot.create(:bank_account)
    end

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
end
