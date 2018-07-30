class ClearOldOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args) 
    Order.old.destroy_all
  end
end