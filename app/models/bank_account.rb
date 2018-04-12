class BankAccount < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :bank_number
end
