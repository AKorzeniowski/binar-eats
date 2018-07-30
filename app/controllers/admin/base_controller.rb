class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :authenticate

  def authenticate
    if  authenticate_or_request_with_http_basic 'Enter the password' do |name, password|
      name == 'admin' && password == 'password'
      end
    end
  end
end
