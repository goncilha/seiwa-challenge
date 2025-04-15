# frozen_string_literal: true

class Patient < ApplicationRecord
  enum :status, %i[enabled disabled]

  validates :name, presence: true
  validates :document_number, presence: true, uniqueness: true
end

