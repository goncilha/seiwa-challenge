# frozen_string_literal: true

class MedicalProcedure < ApplicationRecord
  delegate :price, to: :detail

  has_many :details, class_name: "MedicalProcedureDetail"

  validates :name, presence: true

  def detail
    details.last
  end
end
