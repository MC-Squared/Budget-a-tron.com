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
end
