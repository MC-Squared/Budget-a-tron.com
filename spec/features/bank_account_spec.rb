require 'rails_helper'

describe 'redirection' do
  describe 'index' do
    it 'does not allow access without being signed in' do
      visit bank_accounts_path
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

describe 'navigate' do
  let(:user) do
    FactoryBot.create(:user)
  end
  describe 'index' do
    before do
      login_as user
      visit bank_accounts_path
    end

    it 'can be reached successfully' do
      expect(page).to have_http_status(:success)
    end

    it 'has a tile of Bank Accounts' do
      expect(page).to have_content(/Bank Accounts/)
    end

    it 'has a list of bank accounts' do
      bank_account = FactoryBot.create(:bank_account)
      bank_account.update!(user: user)
      second_account = FactoryBot.create(:second_bank_account)
      second_account.update!(user: user)

      visit bank_accounts_path
      expect(page).to have_text bank_account.name
      expect(page).to have_text second_account.name
    end

    it 'has a scope so that users can only see their own accounts' do
      other_user = FactoryBot.create(:second_user)
      other_user_account = BankAccount.create(
                                        user: other_user,
                                        name: 'should be hidden',
                                        bank_number: 'dont see me'
                                      )

      visit bank_accounts_path
      expect(page).to_not have_content(/should be hidden/)
    end
  end
end
