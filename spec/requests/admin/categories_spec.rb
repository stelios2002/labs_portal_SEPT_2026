require "rails_helper"

RSpec.describe "Admin::Categories", type: :request do
  it "απορρίπτει χωρίς Basic Auth credentials" do
    get admin_categories_path
    expect(response).to have_http_status(401)
  end

  it "επιτρέπει με σωστά credentials" do
    get admin_categories_path, headers: {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(
        Rails.application.credentials.dig(:admin, :username),
        Rails.application.credentials.dig(:admin, :password)
      )
    }
    expect(response).to have_http_status(200)
  end
end