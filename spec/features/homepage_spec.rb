require 'rails_helper'

describe 'Homepage' do
  before do
    visit root_path
  end

  it "can be reached successfully" do
    expect(page).to have_http_status(:success)
  end

  it "shows login and register to guest users" do
    expect(page).to have_selector('nav .login')
    expect(page).to have_selector('nav .register')
  end

  it "hides logout from guest users" do
    expect(page).to_not have_selector('nav .logout')
  end

  it "shows logout to logged in users" do
    user = FactoryBot.create(:user)
    login_as(user)
    visit root_path
    expect(page).to have_selector('nav .logout')
  end

  it "hides login and register from logged in users" do
    user = FactoryBot.create(:user)
    login_as(user)
    visit root_path
    expect(page).to_not have_selector('nav .login')
    expect(page).to_not have_selector('nav .register')
  end
end
