class DebtPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      user.admin? ? scope.all : scope.where(user:user)
    end
  end

  # def index?
  #   true
  # end

  def show?
    record.user == user
  end

  def new?
    create?
  end

  def create?
    true
  end
end
