require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  describe "creation" do
    it "can be created if valid" do
      user = FactoryBot.create(:user)
      account = BankAccount.create(
        user: user,
        name: 'bank account',
        start_balance: 10
      )
      expect(account).to be_valid
    end
  end

  describe "balance_before_date" do
    it "should sum amounts prior to the given date" do
      user = FactoryBot.create(:user)
      account = BankAccount.create(
        user: user,
        name: 'bank account',
        start_balance: 0
      )
      BankTransaction.create(
        bank_account: account,
        amount: 123,
        date: Date.today - 3.days
      )
      BankTransaction.create(
        bank_account: account,
        amount: 456,
        date: Date.today - 2.days
      )
      BankTransaction.create(
        bank_account: account,
        amount: 999,
        date: Date.today
      )

      expect(account.balance_before_date(Date.today)).to eq(123 + 456)
    end

    it "should include the start balance" do
      user = FactoryBot.create(:user)
      account = BankAccount.create(
        user: user,
        name: 'bank account',
        start_balance: 100
      )
      BankTransaction.create(
        bank_account: account,
        amount: 123,
        date: Date.today - 3.days
      )

      expect(account.balance_before_date(Date.today)).to eq(100 + 123)
    end
  end
end
