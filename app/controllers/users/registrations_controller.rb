# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  def update; end

  protected

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[account_number nickname])
  end
end
