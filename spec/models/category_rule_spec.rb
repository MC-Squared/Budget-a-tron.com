require 'rails_helper'

RSpec.describe CategoryRule, type: :model do
  describe "creation" do
    it "can be created if valid" do
      category = FactoryBot.create(:category)
      rule = CategoryRule.create(category: category)
      expect(rule).to be_valid
    end
  end

  describe 'find_category_for_transaction' do
    let(:bank_account) { FactoryBot.create(:bank_account) }
    let(:user) { bank_account.user }
    let(:category1) { FactoryBot.create(:category, user: user, name: 'Cat1') }
    let(:category2) { FactoryBot.create(:category, user: user, name: 'Cat2') }

    let(:trans) do
      BankTransaction.create(bank_account: bank_account,
        payee: 'test payee',
        memo: 'test memo',
        amount: 1234)
    end

    it 'finds the correct category' do
      category_rule1 = CategoryRule.create(category: category1,
                                      match_payee: 'payee',
                                      match_memo: 'memo')
      category_rule2 = CategoryRule.create(category: category2,
                                      match_payee: 'asdf',
                                      match_memo: 'qwer')


      expect(user.category_rules.find_category_for_transaction(trans)).to eq(category1)
    end

    it 'return nil when no match found' do
      category_rule1 = CategoryRule.create(category: category1,
                                      match_payee: 'payee',
                                      match_memo: 'asdf')
      category_rule2 = CategoryRule.create(category: category2,
                                      match_payee: 'asdf',
                                      match_memo: 'qwer')

      expect(user.category_rules.find_category_for_transaction(trans)).to eq(nil)
    end
  end
end
