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
        expect(current_path).to eq(bank_accounts_path)
      end

      it 'has a tile of Bank Accounts' do
        expect(page).to have_content(/Overview/)
      end

      it 'has a list of bank accounts' do
        bank_account = FactoryBot.create(:bank_account, user: user)
        second_account = FactoryBot.create(:second_bank_account, user: user)

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

      it 'has a link to the new bank account page' do
        click_link('new_bank_account')
        expect(current_path).to eq(new_bank_account_path)
      end

      it 'has a list of categories' do
        category1 = FactoryBot.create(:category, name: 'testing', user: user)
        category2 = FactoryBot.create(:category, name: 'asdf', user: user)

        visit bank_accounts_path
        expect(page).to have_text category1.name
        expect(page).to have_text category2.name
      end

      it 'only shows categories for the signed in user' do
        category = FactoryBot.create(:category, user: user)
        other_user = FactoryBot.create(:user)

        other_category = Category.create(name: 'dont see me', user: other_user)

        visit bank_accounts_path
        expect(page).to have_content(category.name)
        expect(page).to_not have_content(other_category.name)
      end

      it 'has a link to the new page' do
        click_link('new_category')
        expect(current_path).to eq(new_category_path)
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
        expect(current_path).to eq(edit_bank_account_path(account))
      end

      it 'cannot be viewed by a non authorized user' do
        logout(:user)
        login_as(FactoryBot.create(:second_user))

        visit bank_account_path(account)
        expect(current_path).to eq(root_path)
      end

      it 'has a list of bank transactions' do
        trans1 = FactoryBot.create(:bank_transaction,
                                    bank_account: account,
                                    payee: 'see this payee');
        trans2 = FactoryBot.create(:bank_transaction,
                                    bank_account: account,
                                    memo: 'see this memo');
        visit bank_account_path(account)
        expect(page).to have_text(trans1.payee)
        expect(page).to have_text(trans1.memo)
      end
    end

    describe 'creation' do
      before do
        login_as user
        visit new_bank_account_path
      end

      it 'has a new form that can be reached' do
        expect(current_path).to eq(new_bank_account_path)
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
        expect(current_path).to eq(edit_bank_account_path(account))
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
      let(:bank_account_to_delete) do
        FactoryBot.create(:bank_account)
      end

      let(:delete_user) do
        bank_account_to_delete.user
      end

      before do
        logout(:user)
        login_as(delete_user, :scope => :user)
        visit edit_bank_account_path(bank_account_to_delete)
      end

      it 'can be deleted' do
        expect { click_on 'delete_bank_account' }.to change(BankAccount, :count).by(-1)
        expect(current_path).to eq(bank_accounts_path)
      end

      it 'can only be deleted by owner' do
        bank_account_to_delete.update!(user: user)

        expect { click_on 'delete_bank_account' }.to change(BankAccount, :count).by(0)
        expect(current_path).to eq(root_path)
      end
    end
  end
end
