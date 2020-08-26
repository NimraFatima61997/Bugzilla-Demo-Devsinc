class ProjectPolicy < ApplicationPolicy
    def index?
      true
    end
    def create?
      return true if user.present? && user.user_type == "Manager"
    end
    def add?
      return true if user.present? && user.user_type == "Manager"
    end
    def remove?
      return true if user.present? && user.user_type == "Manager"
    end
    def update?
      return true if user.present? && user == project.users.find(user.id) && user.user_type == "Manager"
    end
   
    def destroy?
      return true if user.present? && user == project.users.find(user.id) && user.user_type == "Manager"
    end
   
    private
   
      def project
        record
      end
  end