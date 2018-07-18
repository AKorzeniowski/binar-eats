class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :account_number, length: { is: 26 }, allow_blank: true, numericality: { only_integer: true }
  validates :nickname, format: { with: /\A[a-zA-Z]+\z/, message: "must have only letters" }, allow_blank: true
end
