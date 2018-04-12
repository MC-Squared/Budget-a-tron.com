require 'rails_helper'

describe 'redirection' do
  describe 'index' do
    it 'does not allow access without being signed in' do
      visit bank_accounts_path
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'show' do
    it 'does not allow access without being signed in' do
      account = FactoryBot.create(:bank_account)
      visit bank_account_path(account)
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'new' do
    it 'does not allow access without being signed in' do
      visit new_bank_account_path
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'edit' do
    it 'does not allow access without being signed in' do
      account = FactoryBot.create(:bank_account)
      visit edit_bank_account_path(account)
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
      expect(page.status_code).to eq(200)
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

    it 'has a link to the new page' do
      click_link('new_bank_account')
      expect(page.status_code).to eq(200)
    end
  end

  describe 'show' do
    let(:account) do
      account = FactoryBot.create(:bank_account)
      account.update!(user: user)
      account
    end

    before do
      account
      login_as user
      visit bank_account_path(account)
    end

    it 'show account information' do
      expect(page).to have_content(account.name)
    end

    it 'has a link to the edit page' do
      click_link('edit_bank_account')
      expect(page.status_code).to eq(200)
    end
  end

  describe 'creation' do
    before do
      login_as user
      visit new_bank_account_path
    end

    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    it 'can be created from new form page' do
      fill_in 'bank_account[name]', with: 'Test Account Name'
      fill_in 'bank_account[bank_number]', with: '123-test-456'

      expect { click_on 'Save' }.to change(BankAccount, :count).by(1)
    end

    it 'will have a user associated with it' do
      fill_in 'bank_account[name]', with: 'Test User Assoc'
      fill_in 'bank_account[bank_number]', with: '123-test-456'
      click_on 'Save'

      expect(user.bank_accounts.last.name).to eq('Test User Assoc')
    end
  end

  describe 'edit' do
    let(:account) do
      account = FactoryBot.create(:bank_account)
      account.update!(user: user)
      account
    end

    before do
      account
      login_as user

      visit edit_bank_account_path(account)
    end

    it 'has an edit form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    it 'can be edited from edit form page' do
      fill_in 'bank_account[name]', with: 'Test Account Name'
      fill_in 'bank_account[bank_number]', with: 'Edited Number'
      click_on 'Save'

      expect(page).to have_content(/Edited Number/)
    end
  end
end
