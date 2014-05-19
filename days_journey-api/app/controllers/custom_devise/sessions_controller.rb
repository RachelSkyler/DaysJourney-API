class CustomDevise::SessionsController < Devise::SessionsController
	prepend_before_filter :require_no_authentication, only: [:create ]
	include Devise::Controllers::Helpers

	# This controller only respond to json format.
	respond_to :json

	# Customizing for rendering with json format. 
	def create
		build_resource 

    resource = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
<<<<<<< HEAD
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
=======
        render json: { 
        	result: 1,
    			user_id: resource.id,
    			encrypted_password: resource.encrypted_password
    		}
        return
>>>>>>> 98a5f53799f13543d785b43f58fe204fe1eaa8a7
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
<<<<<<< HEAD
    render json: { result: 0 ,error: ["Invalid email or password."] }
=======
    render json: { result: 0 ,errors: ["Invalid email or password."] }
>>>>>>> 98a5f53799f13543d785b43f58fe204fe1eaa8a7
	end

	private 

	# Setting hash and Making resource.
	# Maybe creating new session.
	def build_resource(hash=nil)
  	hash ||= {email: params[:email], password: params[:password]} || {}
  	self.resource = resource_class.new_with_session(hash, session)
	end
end
