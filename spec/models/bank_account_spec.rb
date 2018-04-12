require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  describe "creation" do
    it "can be created if valid" do
      user = FactoryBot.create(:user)
      account = BankAccount.create(
        user: user,
        name: 'bank account',
        bank_number: '123-fake-number'
      )
      expect(account).to be_valid
    end
  end
end