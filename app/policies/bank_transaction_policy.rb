class BankTransactionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.bank_transactions
    end
  end
end
