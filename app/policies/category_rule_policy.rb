class CategoryRulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.category_rules
    end
  end
end
