class UserPolicy < ApplicationPolicy
    def manager?
       user.user_type == "Manager"
    end
    def qa?
        user.user_type == "QA" 
     end
     def developer?
        user.user_type == "Developer"
     end
     def qa_and_developer?
        user.user_type == "QA" ||  user.user_type == "Developer"
     end
end