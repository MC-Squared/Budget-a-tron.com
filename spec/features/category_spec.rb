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
      visit categories_path
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'navigation' do
    describe 'index' do
      before do
        login_as category.user
        visit categories_path
      end

      it 'can be reached successfully' do
        expect(page.status_code).to eq(200)
      end

      it 'has a tile of Categories' do
        expect(page).to have_content(/Categories/)
      end

      it 'has a list of categories' do
        cat1 = FactoryBot.create(:category, user: user)
        cat2 = FactoryBot.create(:category, user: user)

        visit categories_path
        expect(page).to have_text cat1.name
        expect(page).to have_text cat2.name
      end

      it 'only shows categories for the signed in user' do
        user = category.user
        other_user = FactoryBot.create(:user)

        other_category = Category.create(name: 'dont see me', user: other_user)

        visit categories_path
        expect(page).to have_content(category.name)
        expect(page).to_not have_content(other_category.name)
      end

      it 'has a link to the new page' do
        click_link('new_category')
        expect(current_path).to eq(new_category_path)
      end
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
      expect(page.status_code).to eq(200)
    end

    it 'can be edited from edit form page' do
      fill_in 'category[name]', with: 'Test Category Name'
      click_on 'Save'

      expect(current_path).to eq(categories_path)
      expect(page).to have_content(/Test Category Name/)
    end

    it 'cannot be edited by a non authorized user' do
      logout(:user)
      login_as(FactoryBot.create(:second_user))

      visit edit_category_path(category)

      expect(current_path).to eq(root_path)
    end

    describe 'delete' do
      it 'can be deleted' do
        logout(:user)

        delete_user = FactoryBot.create(:user)
        category_to_delete = FactoryBot.create(:category, user: delete_user)
        login_as(delete_user, :scope => :user)

        visit edit_category_path(category_to_delete)

        expect { click_on 'delete_category' }.to change(Category, :count).by(-1)
        expect(page.status_code).to eq(200)
      end

      it 'can only be deleted by owner' do
        logout(:user)

        delete_user = FactoryBot.create(:user)
        login_as(delete_user)

        category_to_delete = FactoryBot.create(:category, user: delete_user)

        visit edit_category_path(category_to_delete)

        category_to_delete.update!(user: user)

        expect { click_on 'delete_category' }.to change(Category, :count).by(0)
        expect(current_path).to eq(root_path)
      end
    end
  end
end
