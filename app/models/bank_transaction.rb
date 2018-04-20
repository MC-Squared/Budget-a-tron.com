class BankTransaction < ApplicationRecord
  belongs_to :bank_account
  delegate :user, to: :bank_account
  belongs_to :category, optional: true

  validates_presence_of :amount

  scope :sum_by_day, -> { group(:date).sum(:amount) }
end
