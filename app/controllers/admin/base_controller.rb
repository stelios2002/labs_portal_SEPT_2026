module Admin
  class BaseController < ApplicationController
    before_action :set_admin_context
    
    http_basic_authenticate_with(
      name: Rails.application.credentials.dig(:admin, :username),
      password: Rails.application.credentials.dig(:admin, :password)
    )

    private

    def set_admin_context
      @admin_context = true
    end
  end
end