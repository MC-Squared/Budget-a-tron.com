class UncategorizedBankTransactionsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @bank_transactions = policy_scope(BankTransaction)
                           .includes(:bank_account)
                           .where(category: nil)
                           .order("ABS(amount) DESC")

    @categories = policy_scope(Category).ordered_by_name
  end
end
