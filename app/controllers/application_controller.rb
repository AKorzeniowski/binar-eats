class ApplicationController < ActionController::Base

 before_action :set_timezone

 def set_timezone
   Time.zone = 'Warsaw'
 end

end
