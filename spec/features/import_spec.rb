require 'rails_helper'

describe 'navigate' do
  let(:bank_account) do
    FactoryBot.create(:bank_account)
  end

  let(:user) do
    bank_account.user
  end

  describe 'creation' do
    before do
      login_as user
      visit bank_account_path(bank_account)
      attach_file("file", Rails.root + 'spec/fixtures/sample.qif')
    end

    it 'can be created from the bank account show page' do
      expect { click_on 'Import' }.to change(BankTransaction, :count).by(2)
    end

    it 'redirects to show page' do
      click_on 'Import'
      expect(current_path).to eq(bank_account_path(bank_account))
    end
  end

end
