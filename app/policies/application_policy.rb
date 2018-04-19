class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    record_exists_for_user?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    record_exists_for_user?
  end

  def edit?
    update?
  end

  def destroy?
    record_exists_for_user?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(user: user)
    end
  end

  private

  def record_exists_for_user?
    scope.where(id: record.id).exists?
  end
end
