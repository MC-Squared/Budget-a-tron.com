class BankTransactionPolicy < ApplicationPolicy
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
    record.bank_account.user_id == user.id
  end
end
