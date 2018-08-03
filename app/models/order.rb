class Order < ApplicationRecord
  validates :creator, :deadline, :place, presence: true

  belongs_to :creator, class_name: 'User'
  belongs_to :orderer, class_name: 'User', optional: true
  belongs_to :deliverer, class_name: 'User', optional: true
  belongs_to :place
  has_many :items, dependent: :destroy

  default_scope { order(deadline: :asc) }

  scope :old, -> {
    where('DATE(deadline) < ?', Time.zone.today)
  }

  scope :my_orders, ->(creator_id) {
    where('creator_id = ? AND DATE(deadline) = ?', creator_id, Time.zone.today)
  }
  scope :other_orders, ->(creator_id) {
    where.not('creator_id = ?', creator_id).where('DATE(deadline) = ?', Time.zone.today)
  }

  def allowed_to_see_payment?(user)
    (delivery_by_restaurant == true && user.id == orderer_id) ||
      (delivery_by_restaurant == false && user.id == deliverer_id)
  end

  def update_delivery_notification
    Sidekiq::ScheduledSet.new.select { delivery_notification }.each(&:delete) if delivery_notification.present?
    self.delivery_notification = OrderDeliveryNotificationJob.
      set(wait_until: delivery_time - 5.minutes).perform_later(id).job_id
  end

  def update_last_deliverer_orderer_job
    Sidekiq::ScheduledSet.new.select { deadline_ord_deli_job }.each(&:delete) if deadline_ord_deli_job.present?
    self.deadline_ord_deli_job = DeadlineOrdererDelivererJob.set(wait_until: deadline).
      perform_later(id).job_id
  end

  def update_deadline_notification
    Sidekiq::ScheduledSet.new.select { deadline_notification }.each(&:delete) if deadline_notification.present?
    self.deadline_notification = NotificationOrderDeadline.
      set(wait_until: deadline - 5.minutes).perform_later(id).job_id
  end
end
