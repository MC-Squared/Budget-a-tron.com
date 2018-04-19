class CategoryPolicy < ApplicationPolicy

  def show?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
