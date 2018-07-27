class HomeController < ApplicationController
  def welcome
    redirect_to orders_url if current_user
  end
end
