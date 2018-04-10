require 'rails_helper'

describe 'Homepage' do
  it "can be reached successfully" do
    visit root_path
    expect(page).to have_http_status(:success)
  end

end
