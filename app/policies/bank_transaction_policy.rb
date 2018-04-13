class BankTransactionPolicy < ApplicationPolicy
  attr_reader :user, :bank_transaction

  def initialize(user, bank_transaction)
    @user = user
    @bank_transaction = bank_transaction
  end

  def show?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  private

  def user_is_owner?
    @bank_transaction.bank_account.user_id == @user.id
  end
end
