class BankAccount < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :bank_number, :start_balance

  has_many :bank_transactions
  has_many :categories, through: :bank_transactions
end
