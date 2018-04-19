class BankTransaction < ApplicationRecord
  belongs_to :bank_account

  validates_presence_of :amount

  scope :sum_by_day, -> { group(:date).sum(:amount) }
end
