class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :configure_permitted_parameters, only: [:create]

  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email password password_confirmation])
  end
end
