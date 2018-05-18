module BankTransactionsCumulativeSums
  extend ActiveSupport::Concern

  def calculate_cumulative_sums_by_day(args={})
    dates = args[:dates].clone || []
    running_total = args[:start_balance] || 0
    bank_transactions = args[:bank_transactions]

    daily_balances = bank_transactions.sum_by_day
    dates = daily_balances.keys.sort if dates.empty?
    return {} if dates.empty?

    cumulative_balances = {}
    dates.unshift(dates.first - 1.day)
    dates.each do |d|
      running_total += daily_balances[d] unless daily_balances[d].nil?
      cumulative_balances[d] = running_total
    end

    cumulative_balances
  end
end
