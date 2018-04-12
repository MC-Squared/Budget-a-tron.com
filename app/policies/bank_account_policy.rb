class BankAccountPolicy < ApplicationPolicy
  attr_reader :user, :bank_account

  def initialize(user, bank_account)
    @user = user
    @bank_account = bank_account
  end

  def show?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  private

  def user_is_owner?
    @bank_account.user_id == @user.id
  end
end
