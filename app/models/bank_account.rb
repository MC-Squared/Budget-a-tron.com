class BankAccount < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :start_balance

  has_many :bank_transactions
  has_many :categories, through: :bank_transactions

  def balance_before_date(date)
    bank_transactions.where('date < ?', date).sum(:amount)
  end
end
