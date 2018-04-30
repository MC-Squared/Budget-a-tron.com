class DashboardController < ApplicationController
  include BankTransactionsCumulativeSums
  include BankTransactionsByCategory
  include BankTransactionsDirectionals
  include DatesPageableByTimespan
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    bank_accounts = policy_scope(BankAccount)
    dates = policy_scope(BankTransaction).get_dates

    @max_page = get_max_page(dates)
    dates = get_dates_for_timespan_page(dates)

    @bank_account_sums = []
    bank_accounts.each do |ba|
      @bank_account_sums << {
        name: ba.name,
        data: calculate_cumulative_sums_by_day(
          bank_transactions: ba.bank_transactions,
          start_balance: ba.balance_before_date(dates.first),
          dates: dates),
      }
    end

    transactions = policy_scope(BankTransaction).for_date(dates)

    @bank_transaction_directionals = sum_by_direction(
      bank_transactions: transactions
    )

    @bank_transactions_by_category = sum_by_category(
      bank_transactions: transactions
    )
  end

  private


end
