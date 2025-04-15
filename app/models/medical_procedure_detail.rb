# frozen_string_literal: true

class MedicalProcedureDetail < ApplicationRecord
  belongs_to :medical_procedure

  validates :price, presence: true, numericality: true
end
