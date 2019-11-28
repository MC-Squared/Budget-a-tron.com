class BankAccount < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :start_balance

  has_many :bank_transactions
  has_many :categories, through: :bank_transactions

  def balance_before_date(date)
    start_balance + bank_transactions.where('date < ?', date).sum(:amount)
  end

  def last_transaction_date
    bank_transactions.order(date: :desc).first.try(:date) || Time.zone.now
  end

  def last_balance
    start_balance + total_transaction_amount
  end

  def last_balance=(new_balance)
    new_balance = new_balance.to_s.gsub(",", "")
    self.start_balance = (BigDecimal(new_balance) - total_transaction_amount)
  end

  def total_transaction_amount
    bank_transactions.sum(:amount)
  end
end
