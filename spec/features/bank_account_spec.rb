require 'rails_helper'

describe 'BankAccount' do
  let(:user) do
    FactoryBot.create(:user)
  end

  let(:account) do
    FactoryBot.create(:bank_account, user: user)
  end

  describe 'authorization' do
    it 'does not allow access without being signed in' do
      visit bank_accounts_path
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'navigate' do
    describe 'index' do
      before do
        login_as user
        visit bank_accounts_path
      end

      it 'can be reached successfully' do
        expect(page.status_code).to eq(200)
      end

      it 'has a tile of Bank Accounts' do
        expect(page).to have_content(/Overview/)
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
        other_user_account = BankAccount.create!(
                                          user: other_user,
                                          name: 'should be hidden',
                                          bank_number: 'dont see me',
                                          start_balance: 0
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
      before do
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

      it 'cannot be viewed by a non authorized user' do
        logout(:user)
        login_as(FactoryBot.create(:second_user))

        visit bank_account_path(account)

        expect(current_path).to eq(root_path)
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
        fill_in 'bank_account[start_balance]', with: 123

        expect { click_on 'Save' }.to change(BankAccount, :count).by(1)
      end

      it 'will have a user associated with it' do
        fill_in 'bank_account[name]', with: 'Test User Assoc'
        fill_in 'bank_account[bank_number]', with: '123-test-456'
        fill_in 'bank_account[start_balance]', with: 456
        click_on 'Save'

        expect(user.bank_accounts.last.name).to eq('Test User Assoc')
      end
    end

    describe 'edit' do
      before do
        login_as user
        visit edit_bank_account_path(account)
      end

      it 'has an edit form that can be reached' do
        expect(page.status_code).to eq(200)
      end

      it 'can be edited from edit form page' do
        fill_in 'bank_account[name]', with: 'Edited Account Name'
        click_on 'Save'

        expect(page).to have_content(/Edited Account Name/)
      end

      it 'cannot be edited by a non authorized user' do
        logout(:user)
        login_as(FactoryBot.create(:second_user))

        visit edit_bank_account_path(account)

        expect(current_path).to eq(root_path)
      end
    end

    describe 'delete' do
      it 'can be deleted' do
        logout(:user)

        delete_user = FactoryBot.create(:user)
        login_as(delete_user, :scope => :user)

        bank_account_to_delete = BankAccount.create!(
          name: 'name',
          bank_number: 'asdf',
          user: delete_user,
          start_balance: 0
        )

        visit edit_bank_account_path(bank_account_to_delete)

        expect { click_on 'delete_bank_account' }.to change(BankAccount, :count).by(-1)
        expect(page.status_code).to eq(200)
      end

      it 'can only be deleted by owner' do
        logout(:user)

        delete_user = FactoryBot.create(:user)
        login_as(delete_user)

        bank_account_to_delete = BankAccount.create!(
          name: 'name',
          bank_number: 'asdf',
          user: delete_user,
          start_balance: 0
        )

        visit edit_bank_account_path(bank_account_to_delete)

        bank_account_to_delete.update!(user: user)

        expect { click_on 'delete_bank_account' }.to change(BankAccount, :count).by(0)
        expect(current_path).to eq(root_path)
      end
    end
  end
end
