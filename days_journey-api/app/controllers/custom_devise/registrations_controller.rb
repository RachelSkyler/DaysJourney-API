class CustomDevise::RegistrationsController < Devise::RegistrationsController 
  
  # This controller only respond to json format.
  respond_to :json

  prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        return render json: {
          result: 1,
          user_id: resource.id,
          encrypted_password: resource.encrypted_password
        }
      else
        expire_data_after_sign_in!
        return render json: {
          result: 0,
          error: "Fail Active authentication"
        }
      end
    else
      clean_up_passwords resource
      return render json: {
        result: 0,
        error: resource.errors
      }
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def sign_up_params
    params.permit(:email, :password, :user_name)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end
end