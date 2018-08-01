class ClearOldOrdersJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Order.old.destroy_all
  end
end
