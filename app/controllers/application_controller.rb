class ApplicationController < ActionController::Base
  around_action :set_time_zone
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_time_zone(&block)
    tz = cookies[:browser_tz]
    Time.use_zone(tz.presence || "UTC", &block)
  end
end