module BankTransactionsDirectionals
  extend ActiveSupport::Concern

  def sum_by_direction(args={})
    bank_transactions = args[:bank_transactions]
    return [] if bank_transactions.nil?

    [
      [ 'Incoming',
        bank_transactions.positive_amount_sum
      ],
      [ 'Outgoing',
        bank_transactions.negative_amount_sum
      ]
    ]
  end
end
