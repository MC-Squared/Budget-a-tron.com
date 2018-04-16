module BankAccountsHelper
  def get_sidebar_bank_accounts
    current_user.bank_accounts.order(name: :desc)
  end
end
