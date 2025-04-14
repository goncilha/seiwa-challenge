# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum :status, %i[enabled disabled]

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
