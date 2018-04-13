require 'rails_helper'

RSpec.describe BankTransaction, type: :model do
  describe "creation" do
    it "can be created if valid" do
      bank_account = FactoryBot.create(:bank_account)
      transaction = BankTransaction.create(
        bank_account: bank_account,
        payee: 'test payee',
        amount: 123.45,
      )
      expect(transaction).to be_valid
    end
    it "requires an amount" do
      bank_account = FactoryBot.create(:bank_account)
      transaction = BankTransaction.create(
        bank_account: bank_account,
        payee: 'test payee',
      )
      expect(transaction).to_not be_valid
    end
  end
end
