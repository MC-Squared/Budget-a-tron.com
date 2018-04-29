require 'rails_helper'

describe 'Dashboard' do
  let(:user) do
    FactoryBot.create(:user)
  end

  let(:account) do
    FactoryBot.create(:bank_account, user: user)
  end

  describe 'authorization' do
    it 'does not allow access without being signed in' do
      visit dashboard_path
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'navigate' do
    describe 'index' do
      before do
        login_as user
        visit dashboard_path
      end

      it 'can be reached successfully' do
        expect(current_path).to eq(dashboard_path)
      end

      it 'has a tile of Overview' do
        expect(page).to have_content(/Overview/)
      end

      it 'has a list of bank accounts' do
        bank_account = FactoryBot.create(:bank_account, user: user)
        second_account = FactoryBot.create(:second_bank_account, user: user)

        visit dashboard_path
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

        visit dashboard_path
        expect(page).to_not have_content(/should be hidden/)
      end

      it 'has a link to the new bank account page' do
        click_link('new_bank_account')
        expect(current_path).to eq(new_bank_account_path)
      end

      it 'has a list of categories' do
        category1 = FactoryBot.create(:category, name: 'testing', user: user)
        category2 = FactoryBot.create(:category, name: 'asdf', user: user)

        visit dashboard_path
        expect(page).to have_text category1.name
        expect(page).to have_text category2.name
      end

      it 'only shows categories for the signed in user' do
        category = FactoryBot.create(:category, user: user)
        other_user = FactoryBot.create(:user)

        other_category = Category.create(name: 'dont see me', user: other_user)

        visit dashboard_path
        expect(page).to have_content(category.name)
        expect(page).to_not have_content(other_category.name)
      end

      it 'has a link to the new page' do
        click_link('new_category')
        expect(current_path).to eq(new_category_path)
      end
    end
  end
end
