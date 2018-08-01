class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :authenticate

  def authenticate
    redirect_to root_path, alert: 'No permissions' unless current_user && current_user.admin?
  end
end
