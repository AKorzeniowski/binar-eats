class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :authenticate

  def authenticate
    if current_user.admin == 1
      return
    else
      rediret_to root_path, alert: 'No permissions'  
    end
  end
end
