module BankTransactionsByCategory
  extend ActiveSupport::Concern

  def sum_by_category(args={})
    bank_transactions = args[:bank_transactions]
    return [] if bank_transactions.nil?

    bank_transactions
      .sum_by_category
      .map { |cat_sum|
        [
          cat_sum[0].try(:name) || 'No Category',
          cat_sum[1]
        ]
      }
  end
end
