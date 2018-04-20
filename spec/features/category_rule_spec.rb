require 'rails_helper'

describe 'category' do
  let(:category_rule) do
    FactoryBot.create(:category_rule)
  end

  let(:category) do
    category_rule.category
  end

  let(:user) do
    category_rule.user
  end

  describe 'authorization' do
    it 'does not allow access without being signed in' do
      visit category_rules_path
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'navigation' do
    describe 'index' do
      before do
        login_as user
        visit category_rules_path
      end

      it 'can be reached successfully' do
        expect(current_path).to eq(category_rules_path)
      end

      it 'has a tile of Categories' do
        expect(page).to have_content(/Category Rules/)
      end

      it 'has a list of category rules' do
        rule1 = FactoryBot.create(:category_rule, match_payee: 'payee 1', category: category)
        rule2 = FactoryBot.create(:category_rule, match_memo: 'test memo', category: category)

        visit category_rules_path
        expect(page).to have_text rule1.match_payee
        expect(page).to have_text rule2.match_memo
      end

      it 'only shows category rules for the signed in user' do
        other_category_rule = FactoryBot.create(:category_rule, match_payee: 'dont see me')

        visit category_rules_path
        expect(page).to have_content(category_rule.match_payee)
        expect(page).to_not have_content(other_category_rule.match_payee)
      end

      it 'has a link to the new page' do
        click_link('new_category_rule')
        expect(current_path).to eq(new_category_rule_path)
      end
    end
  end

  describe 'show' do
    before do
      login_as user
      visit category_rule_path(category_rule)
    end

    it 'show account information' do
      expect(page).to have_content(category_rule.match_payee)
    end

    it 'has a link to the edit page' do
      click_link('edit_category_rule')
      expect(current_path).to eq(edit_category_rule_path(category_rule))
    end

    it 'cannot be viewed by a non authorized user' do
      logout(:user)
      login_as(FactoryBot.create(:second_user))

      visit category_rule_path(category_rule)

      expect(current_path).to eq(root_path)
    end
  end

  describe 'creation' do
    before do
      login_as user
      visit new_category_rule_path
    end

    it 'has a new form that can be reached' do
      expect(current_path).to eq(new_category_rule_path)
    end

    it 'can be created from new form page' do
      select category.name, from: 'category_rule[category_id]'
      fill_in 'category_rule[match_payee]', with: 'Test Match Payee'

      expect { click_on 'Create Category rule' }.to change(CategoryRule, :count).by(1)
    end

    it 'will have a category associated with it' do
      select category.name, from: 'category_rule[category_id]'
      fill_in 'category_rule[match_payee]', with: 'Test Match Payee'
      click_on 'Create Category rule'

      expect(user.category_rules.last.match_payee).to eq('Test Match Payee')
    end
  end

  describe 'edit' do
    before do
      login_as user
      visit edit_category_rule_path(category_rule)
    end

    it 'has an edit form that can be reached' do
      expect(current_path).to eq(edit_category_rule_path(category_rule))
    end

    it 'can be edited from edit form page' do
      fill_in 'category_rule[match_payee]', with: 'Test Payee Name'
      click_on 'Update Category rule'

      expect(current_path).to eq(category_rules_path)
      expect(page).to have_content(/Test Payee Name/)
    end

    it 'cannot be edited by a non authorized user' do
      logout(:user)
      login_as(FactoryBot.create(:second_user))

      visit edit_category_rule_path(category_rule)

      expect(current_path).to eq(root_path)
    end
  end

  describe 'delete' do
    it 'can be deleted' do
      logout(:user)

      category_rule_to_delete = FactoryBot.create(:category_rule)
      delete_user = category_rule_to_delete.user
      login_as(delete_user, :scope => :user)

      visit edit_category_rule_path(category_rule_to_delete)

      expect { click_on 'delete_category_rule' }.to change(CategoryRule, :count).by(-1)
      expect(current_path).to eq(category_rules_path)
    end

    it 'can only be deleted by owner' do
      logout(:user)

      category_rule_to_delete = FactoryBot.create(:category_rule)
      delete_user = category_rule_to_delete.user
      login_as(delete_user, :scope => :user)

      visit edit_category_rule_path(category_rule_to_delete)

      other_category = FactoryBot.create(:category)

      category_rule_to_delete.update!(category: category)

      expect { click_on 'delete_category_rule' }.to change(CategoryRule, :count).by(0)
      expect(current_path).to eq(root_path)
    end
  end
end
