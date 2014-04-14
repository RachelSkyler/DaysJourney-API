class SessionsController < Devise::SessionsController
    prepend_before_filter :require_no_authentication, only: [:create ]
    include Devise::Controllers::Helpers

    # This controller only respond to json format.
    respond_to :json

    def create
        # Allocate return values that forcely call authenticate method.
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        resource.reset_authentication_token!
        resource.save!
        render json: {
          auth_token: resource.reset_authentication_token,
          user_role: resource.role
        }
        end
 
    def destroy
        sign_out(resource_name)
    end
end
