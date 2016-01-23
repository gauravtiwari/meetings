class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
  :rememberable, :trackable, :validatable, :omniauthable

  include Authenticable
end