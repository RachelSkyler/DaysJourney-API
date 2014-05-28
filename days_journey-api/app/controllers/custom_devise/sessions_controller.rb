class CustomDevise::SessionsController < Devise::SessionsController
	prepend_before_filter :require_no_authentication, only: [:create ]
	include Devise::Controllers::Helpers

	# This controller only respond to json format.
	respond_to :json

	# Customizing for rendering with json format. 
	def create
		build_resource 

    resource = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless resource || resource.valid_password?(params[:password])
    
    result = nil
    result = Path.new_today_path(resource.id) unless Path.has_today_path?(resource.id)

    if result[:path].save && result[:path].destinations[0].save
    	render json: { 
    		result: 1,
    		user_id: resource.id,
    		encrypted_password: resource.encrypted_password
    	}
    else
    	render json: {
    		result: 0,
    		error: "Invalid passoword."
    	}
    end
	end
 
	def destroy
		sign_out(resource_name)
	end

	def respond_with(resource, opts = {})
		render json: resource # Triggers the appropriate serializer
	end

	protected

	def sign_in_params
      params.permit(:email, :password)
  end

  def invalid_login_attempt
      warden.custom_failure!
      render json: { 
    	 result: 0,
    	 error: ["Invalid email or password."] 
      }
	end

	private 

	# Setting hash and Making resource.
	# Maybe creating new session.
	def build_resource(hash=nil)
  	hash ||= {email: params[:email], password: params[:password]} || {}
  	self.resource = resource_class.new_with_session(hash, session)
	end
end
