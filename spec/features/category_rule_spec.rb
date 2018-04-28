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
      visit edit_category_path(category)
      expect(current_path).to eq(new_user_session_path)
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

    it 'will only list categories for the current user' do
      cat2 = FactoryBot.create(:category)
      visit new_category_rule_path

      expect(page).to have_select('category_rule[category_id]', options: [category.name])
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

      expect(current_path).to eq(category_path(category_rule.category))
      expect(page).to have_content(/Test Payee Name/)
    end

    it 'cannot be edited by a non authorized user' do
      logout(:user)
      login_as(FactoryBot.create(:second_user))

      visit edit_category_rule_path(category_rule)

      expect(current_path).to eq(root_path)
    end

    it 'will only list categories for the current user' do
      cat2 = FactoryBot.create(:category)
      visit edit_category_rule_path(category_rule)

      expect(page).to have_select('category_rule[category_id]', options: [category.name])
    end
  end

  describe 'delete' do
    let(:category_rule_to_delete) do
      FactoryBot.create(:category_rule)
    end

    let(:delete_user) do
      category_rule_to_delete.user
    end

    before do
      logout(:user)
      login_as(delete_user, :scope => :user)

      visit edit_category_rule_path(category_rule_to_delete)
    end

    it 'can be deleted' do
      expect { click_on 'delete_category_rule' }.to change(CategoryRule, :count).by(-1)
      expect(current_path).to eq(category_path(category_rule_to_delete.category))
    end

    it 'can only be deleted by owner' do
      other_category = FactoryBot.create(:category)

      category_rule_to_delete.update!(category: category)

      expect { click_on 'delete_category_rule' }.to change(CategoryRule, :count).by(0)
      expect(current_path).to eq(root_path)
    end
  end
end
