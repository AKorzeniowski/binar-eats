class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  validates :account_number, length: { is: 26 }, allow_blank: true, numericality: { only_integer: true }
  validates :nickname, format: { with: /\A[a-zA-Z]+\z/, message: 'must have only letters' }, allow_blank: true

  with_options class_name: 'Order', dependent: :nullify do
    has_many :created_orders, foreign_key: 'creator_id', inverse_of: :creator
    has_many :ordered_orders, foreign_key: 'orderer_id', inverse_of: :orderer
    has_many :received_orders, foreign_key: 'deliverer_id', inverse_of: :deliverer
  end

  has_many :items, dependent: :destroy

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first

      # Uncomment the section below if you want users to be created if they don't exist
      # unless user
      #     user = User.create(name: data['name'],
      #        email: data['email'],
      #        password: Devise.friendly_token[0,20]
      #     )
      # end
      user
  end

  def name
    nickname.presence || email
  end

  def admin?
    admin == 1
  end

end
