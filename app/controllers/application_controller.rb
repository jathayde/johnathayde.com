# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :admin?

  protected

  # Use as `before_action :authenticate_admin!` on protected actions.
  # Credentials come from ENV["ADMIN_USERNAME"] / ENV["ADMIN_PASSWORD"].
  # Uses constant-time comparison to avoid timing attacks.
  def authenticate_admin!
    authenticate_or_request_with_http_basic("Admin Area") do |username, password|
      admin_credentials_match?(username, password)
    end
  end

  # View / controller helper: true when the current request carried valid
  # admin credentials. Useful for conditionally rendering admin affordances
  # on otherwise-public pages without forcing a login challenge.
  def admin?
    authenticate_with_http_basic do |username, password|
      admin_credentials_match?(username, password)
    end == true
  end

  private

  def admin_credentials_match?(username, password)
    expected_user = ENV["ADMIN_USERNAME"].to_s
    expected_pass = ENV["ADMIN_PASSWORD"].to_s
    return false if expected_user.empty? || expected_pass.empty?

    ActiveSupport::SecurityUtils.secure_compare(username.to_s, expected_user) &
      ActiveSupport::SecurityUtils.secure_compare(password.to_s, expected_pass)
  end
end
