# frozen_string_literal: true

class Doctor < ApplicationRecord
  enum :status, %i[enabled disabled]

  validates :name, presence: true
  validates :crm, numericality: { only_integer: true }, length: { maximum: 6 }
  validates :crm_location, presence: true, length: { maximum: 2 }
end
