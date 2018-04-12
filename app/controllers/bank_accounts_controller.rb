class BankAccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = current_user.bank_accounts
  end
end
