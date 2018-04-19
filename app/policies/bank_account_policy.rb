class BankAccountPolicy < ApplicationPolicy
  def show?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end
end
