class DashboardController < ApplicationController
  include BankTransactionsCumulativeSums
  include BankTransactionsByCategory
  include BankTransactionsDirectionals
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    bank_accounts = policy_scope(BankAccount).includes(:bank_transactions)
    dates = policy_scope(BankTransaction).distinct(:date).pluck(:date).sort

    @timespan = params[:timespan].to_sym unless params[:timespan].nil?
    @timespan ||= :all
    @page = params[:page].to_i unless params[:page].nil?

    timespan_to_cover = 0
    case @timespan
    when :year
      timespan_to_cover = 1.year
    when :month
      timespan_to_cover = 1.month
    when :fortnight
      timespan_to_cover = 2.weeks
    when :week
      timespan_to_cover = 1.week
    end

    if @timespan != :all && dates.count > 0
      date_range_days = (dates.last - dates.first).to_i.days
      today_date_range_days = (Date.today - dates.last).to_i.days
      @max_page = date_range_days / timespan_to_cover
      @page ||= (Date.today - dates.last).to_i.days / timespan_to_cover

      start_date = (Date.today - (timespan_to_cover - 2.days)) - (@page * timespan_to_cover)
      dates = (start_date...(start_date + timespan_to_cover - 1.day)).to_a
    end
    @max_page ||= 0
    @page ||= 0

    @bank_account_sums = []
    bank_accounts.each do |ba|
      @bank_account_sums << {
        name: ba.name,
        data: calculate_cumulative_sums_by_day(
          bank_transactions: ba.bank_transactions,
          start_balance: ba.bank_transactions.where('date < ?', dates.first).sum(:amount),
          dates: dates),
      }
    end

    @bank_transaction_directionals = sum_by_direction(
      bank_transactions: policy_scope(BankTransaction)
    )

    @bank_transactions_by_category = sum_by_category(
      bank_transactions: policy_scope(BankTransaction)
    )
  end
end
