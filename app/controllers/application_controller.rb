class ApplicationController < ActionController::Base
    include Pundit
    protect_from_forgery with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def after_sign_in_path_for(resource)
      projects_path(current_user) #your path
    end
    def after_sign_up_path_for(resource)
      projects_path(current_user) #your path
    end
    protected

         def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [:user_type])
         end
       
 
  private
 
    def user_not_authorized
      flash[:warning] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
