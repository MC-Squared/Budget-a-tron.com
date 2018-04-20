require 'rails_helper'

describe 'BankTransaction' do
  let(:bank_transaction) do
    FactoryBot.create(:bank_transaction)
  end

  let(:user) do
    bank_transaction.bank_account.user
  end

  describe 'authorization' do
    it 'does not allow access without being signed in' do
      visit bank_account_bank_transactions_path(bank_transaction.bank_account)
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'navigate' do
    describe 'index' do
      before do
        login_as bank_transaction.bank_account.user
        visit bank_account_bank_transactions_path(bank_transaction.bank_account)
      end

      it 'can be reached successfully' do
        expect(current_path).to eq(bank_account_bank_transactions_path(bank_transaction.bank_account))
      end

      it 'has a tile of Account Transactions' do
        expect(page).to have_content(/Account Transactions/)
      end

      it 'has a list of transactions' do
        bank_account = FactoryBot.create(:bank_account)
        trans1 = FactoryBot.create(:bank_transaction, bank_account: bank_account)
        trans2 = FactoryBot.create(:second_bank_transaction, bank_account: bank_account)

        login_as bank_account.user
        visit bank_account_bank_transactions_path(bank_account)
        expect(page).to have_text trans1.payee
        expect(page).to have_text trans2.payee
      end

      it 'only shows transactions from the given account' do
        user = bank_transaction.bank_account.user
        bank_account = FactoryBot.create(:bank_account, user: user)
        other_account = FactoryBot.create(:second_bank_account, user: user)
        transaction = BankTransaction.create!(
                                          bank_account: bank_account,
                                          payee: 'should be visible',
                                          amount: 123
                                        )
        other_transaction = BankTransaction.create!(
                                          bank_account: other_account,
                                          payee: 'dont see me',
                                          amount: 456
                                        )

        visit bank_account_bank_transactions_path(bank_account)
        expect(page).to have_content(transaction.payee)
        expect(page).to_not have_content(other_transaction.payee)
      end

      it 'has a link to the new page' do
        click_link('new_bank_transaction')
        expect(current_path).to eq(new_bank_account_bank_transaction_path(bank_transaction.bank_account))
      end
    end

    describe 'show' do
      before do
        login_as bank_transaction.bank_account.user
        visit bank_account_bank_transaction_path(bank_transaction.bank_account, bank_transaction)
      end

      it 'show transaction information' do
        expect(page).to have_content(bank_transaction.payee)
      end

      it 'has a link to the edit page' do
        click_link('edit_bank_transaction')
        expect(current_path).to eq(edit_bank_account_bank_transaction_path(bank_transaction.bank_account, bank_transaction))
      end

      it 'cannot be viewed by a non authorized user' do
        logout(:user)
        login_as(FactoryBot.create(:second_user))

        visit bank_account_bank_transaction_path(bank_transaction.bank_account, bank_transaction)

        expect(current_path).to eq(root_path)
      end
    end

    describe 'creation' do
      before do
        login_as user
        visit new_bank_account_bank_transaction_path(bank_transaction.bank_account)
      end

      it 'has a new form that can be reached' do
        expect(current_path).to eq(new_bank_account_bank_transaction_path(bank_transaction.bank_account))
      end

      it 'can be created from new form page' do
        fill_in 'bank_transaction[payee]', with: 'Test Payee'
        fill_in 'bank_transaction[amount]', with: '123.456'

        expect { click_on 'Create Bank transaction' }.to change(BankTransaction, :count).by(1)
      end

      it 'will have a user associated with it' do
        fill_in 'bank_transaction[payee]', with: 'Test Payee User'
        fill_in 'bank_transaction[amount]', with: '123.456'
        click_on 'Create Bank transaction'

        expect(user.bank_transactions.last.payee).to eq('Test Payee User')
      end

      it 'will have an account associated with it' do
        fill_in 'bank_transaction[payee]', with: 'Test Payee Account'
        fill_in 'bank_transaction[amount]', with: '123.456'
        click_on 'Create Bank transaction'

        expect(user.bank_accounts.last.bank_transactions.last.payee).to eq('Test Payee Account')
      end
    end

    describe 'edit' do
      before do
        login_as user
        visit edit_bank_account_bank_transaction_path(bank_transaction.bank_account, bank_transaction)
      end

      it 'has an edit form that can be reached' do
        expect(current_path).to eq(edit_bank_account_bank_transaction_path(bank_transaction.bank_account, bank_transaction))
      end

      it 'can be edited from edit form page' do
        fill_in 'bank_transaction[payee]', with: 'Test Account Payee'
        fill_in 'bank_transaction[amount]', with: 123.45
        click_on 'Update Bank transaction'

        expect(page).to have_content(/Test Account Payee/)
      end

      it 'cannot be edited by a non authorized user' do
        logout(:user)
        login_as(FactoryBot.create(:second_user))

        visit edit_bank_account_bank_transaction_path(bank_transaction.bank_account, bank_transaction)

        expect(current_path).to eq(root_path)
      end
    end

    describe 'delete' do
      let(:bank_transaction_to_delete) do
        FactoryBot.create(:bank_transaction,
          payee: 'test payee',
          amount: 123.99
        )
      end

      let(:bank_account) do
        bank_transaction_to_delete.bank_account
      end

      let(:delete_user) do
        bank_account.user
      end

      before do
        logout(:user)
        login_as(delete_user)

        visit edit_bank_account_bank_transaction_path(bank_account, bank_transaction_to_delete)
      end

      it 'can be deleted' do
        expect { click_on 'delete_bank_transaction' }.to change(BankTransaction, :count).by(-1)
        expect(current_path).to eq(bank_account_bank_transactions_path(bank_account))
      end

      it 'can only be deleted by owner' do
        new_account = FactoryBot.create(:bank_account)
        bank_transaction_to_delete.update!(bank_account: new_account)

        expect { click_on 'delete_bank_transaction' }.to change(BankTransaction, :count).by(0)
        expect(current_path).to eq(root_path)
      end
    end
  end
end
