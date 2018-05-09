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
      visit bank_account_path(account)
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'navigate' do
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
        fill_in 'bank_account[start_balance]', with: 123

        expect { click_on 'Save' }.to change(BankAccount, :count).by(1)
      end

      it 'will have a user associated with it' do
        fill_in 'bank_account[name]', with: 'Test User Assoc'
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
        expect(current_path).to eq(dashboard_path)
      end

      it 'can only be deleted by owner' do
        bank_account_to_delete.update!(user: user)

        expect { click_on 'delete_bank_account' }.to change(BankAccount, :count).by(0)
        expect(current_path).to eq(root_path)
      end
    end
  end
end
