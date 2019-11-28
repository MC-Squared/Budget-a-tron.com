class UncategorizedBankTransactionsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @bank_transactions = policy_scope(BankTransaction)
                           .includes(:category)
                           .where(category: nil)
                           .order("ABS(amount) DESC")
  end
end
