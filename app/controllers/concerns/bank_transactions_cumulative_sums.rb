module BankTransactionsCumulativeSums
  extend ActiveSupport::Concern

  def calculate_cumulative_sums_by_day(args={})
    dates = args[:dates] || []
    running_total = args[:start_balance] || 0
    bank_transactions = args[:bank_transactions]

    daily_balances = bank_transactions.sum_by_day
    dates = daily_balances.keys.sort if dates.empty?
    return {} if dates.empty?

    dates.unshift(dates.first - 1.day)
    dates.each do |d|
      daily_balances[d] ||= 0
      daily_balances[d] += running_total
      running_total = daily_balances[d]
    end

    daily_balances
  end
end
