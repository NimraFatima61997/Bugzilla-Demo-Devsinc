class BugPolicy < ApplicationPolicy
  def index?
    true
  end
  def create?
    return true if user.present?  && user.user_type=="QA"   
  end
  def new?
    return true if user.present?  && user.user_type=="QA"   
  end
  def update?
    return true if user.user_type=="QA"
  end
  def assign_resolver?
    return true if user.present?  && user.user_type=="Developer"
  end
  def remove_resolver?
    return true if bug.users.find_by_id(user.id).present?  && user.user_type=="Developer"
  end
  def destroy?
    return true if user.present? && bug.user.id==user.id && user.user_type=="QA"
  end
  def change_status?
    return true if bug.users.find_by_id(user.id).present?  && user.user_type=="Developer"
  end
  private
  
    def bug
      record
    end
end