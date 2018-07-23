class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  validates :account_number, length: { is: 26 }, allow_blank: true, numericality: { only_integer: true }
  validates :nickname, format: { with: /\A[a-zA-Z]+\z/, message: 'must have only letters' }, allow_blank: true

  with_options class_name: 'Order', dependent: :nullify do
    has_many :created_orders, foreign_key: 'creator_id', inverse_of: :creator
    has_many :ordered_orders, foreign_key: 'orderer_id', inverse_of: :orderer
    has_many :received_orders, foreign_key: 'deliverer_id', inverse_of: :receiver
  end

  has_many :items, dependent: :destroy

  def name
    nickname.presence || email
  end
end
