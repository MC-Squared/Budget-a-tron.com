class BankTransaction < ApplicationRecord
  belongs_to :bank_account

  validates_presence_of :amount
end
