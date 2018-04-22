require 'rails_helper'

describe 'category' do
  let(:user) do
    FactoryBot.create(:user)
  end

  let(:category) do
    FactoryBot.create(:category, user: user)
  end

  describe 'authorization' do
    it 'does not allow access without being signed in' do
      visit category_path(category)
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'show' do
    before do
      login_as category.user
      visit category_path(category)
    end

    it 'show account information' do
      expect(page).to have_content(category.name)
    end

    it 'has a link to the edit page' do
      click_link('edit_category')
      expect(current_path).to eq(edit_category_path(category))
    end

    it 'cannot be viewed by a non authorized user' do
      logout(:user)
      login_as(FactoryBot.create(:second_user))

      visit category_path(category)

      expect(current_path).to eq(root_path)
    end
  end

  describe 'creation' do
    before do
      login_as user
      visit new_category_path
    end

    it 'has a new form that can be reached' do
      expect(current_path).to eq(new_category_path)
    end

    it 'can be created from new form page' do
      fill_in 'category[name]', with: 'Test Category'

      expect { click_on 'Save' }.to change(Category, :count).by(1)
    end

    it 'will have a user associated with it' do
      fill_in 'category[name]', with: 'Test Category'
      click_on 'Save'

      expect(user.categories.last.name).to eq('Test Category')
    end
  end

  describe 'edit' do
    before do
      login_as user
      visit edit_category_path(category)
    end

    it 'has an edit form that can be reached' do
      expect(current_path).to eq(edit_category_path(category))
    end

    it 'can be edited from edit form page' do
      fill_in 'category[name]', with: 'Test Category Name'
      click_on 'Save'

      expect(Category.last.name).to eq('Test Category Name')
      expect(page).to have_content(/Test Category Name/)
    end

    it 'cannot be edited by a non authorized user' do
      logout(:user)
      login_as(FactoryBot.create(:second_user))

      visit edit_category_path(category)

      expect(current_path).to eq(root_path)
    end
  end

  describe 'delete' do
    let(:delete_user) do
      FactoryBot.create(:user)
    end

    let(:category_to_delete) do
      FactoryBot.create(:category, user: delete_user)
    end

    before do
      logout(:user)
      login_as(delete_user, :scope => :user)

      visit edit_category_path(category_to_delete)
    end

    it 'can be deleted' do
      expect { click_on 'delete_category' }.to change(Category, :count).by(-1)
      expect(current_path).to eq(bank_accounts_path)
    end

    it 'can only be deleted by owner' do
      category_to_delete.update!(user: user)

      expect { click_on 'delete_category' }.to change(Category, :count).by(0)
      expect(current_path).to eq(root_path)
    end
  end
end
